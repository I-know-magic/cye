package smart.light.base

import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfPTable
import com.smart.common.Redis.RedisClusterUtils
import com.smart.common.ResultJSON
import com.smart.common.exception.ServiceException
import com.smart.common.util.Common
import com.smart.common.util.LightConstants
import com.smart.common.util.LogUtil
import com.smart.common.util.PinYinHelper
import com.smart.common.util.PropertyUtils
import com.smart.common.util.SerialNumberGenerate
import com.smart.common.util.SessionConstants
import com.smart.light.exporter.itextpdf.PdfUtils
import com.smart.light.exporter.itextpdf.WebPdfExporter
import com.smart.light.exporter.jxl.WebXlsTemplateExporter
import com.smart.light.exporter.poi.WebXlsExporter
import com.smart.light.imp.WebXlsImporter
import grails.converters.JSON
import org.apache.commons.lang.StringUtils
import org.apache.poi.xssf.streaming.SXSSFCell
import org.springframework.web.multipart.MultipartFile

import java.text.DecimalFormat

//TODO 修改类注释
/**
 * GoodsController
 * @author CodeGen
 * @generate at 2016-06-12 15:39:49
 */
class GoodsController {
//    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    GoodsService goodsService
    CategoryService categoryService
    GoodsUnitService goodsUnitService

    /**
     * 显示功能页面
     * @params categoryId 菜品类型ID
     * @params backUrl 返回url
     * @params backTitle 返回标题
     */
    def index() {
        def categoryId = params['categoryId'] == null ? '' : params['categoryId']
        def backUrl = params['backUrl'] == null ? '' : params['backUrl']
        def backTitle = params['backTitle'] == null ? '' : params['backTitle']
        categoryId = backUrl == '' ? '' : categoryId
        def isHeader = true//SystemHelper.checkBranchType()
        render(view: "/goods/view", model: ['categoryId': categoryId, 'backUrl': backUrl, 'backTitle': backTitle,isHeader:isHeader])
    }

    /**
     * 菜品批量添加
     * @return
     */
    def addListIndex() {
        def backUrl = params['backUrl'] == null ? '' : params['backUrl']
        render view: '/goods/goodsBatch',model: ['backUrl':backUrl]
    }
    /**
     * 读取菜品单位数据
     * @return
     */
    def getCatAndUnitJson() {
        def result = categoryService.getJson()
        result[0].text = '--请选择--'
        def list = goodsUnitService.getGoodsUnitList()
        GoodsUnit goodsUnit = new GoodsUnit(id: null, unitName: '-- 请选择 --');
        list.add(0, goodsUnit)
        def re = ['cat': result, 'unit': list]
        render re as JSON
    }

    /**
     * 查询列表
     */
    def list() {
        ResultJSON result
        try {
            result = goodsService.queryGoodsList(params)
        } catch (ServiceException se) {
            result = LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 菜品选择对话框加载菜品包括套餐
     */
    def queryList(){
        ResultJSON result
        try {
            result = goodsService.queryGoods(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
            result = LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
            result = LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 保存
     */
    def save() {
        ResultJSON result
        try {
            Goods goods = new Goods(params)
            goods.categoryName = this.getCategoryNameByCategoryId(goods.categoryId)
//            goods.goodsUnitName = this.getGoodsUnitNameByGoodsUnitId(goods.goodsUnitId)
            goods.branchId = LightConstants.getFromSession(session.id, SessionConstants.KEY_BRANCH_ID)?.asType(BigInteger)
            result = goodsService.save(goods)
//            if (result.jsonMap.isReload == "1"){
//                //加入是否刷新库存计算表
//                GoodsStoreList.setReload(1)
//            }
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        result.object = null
        render result
    }

    /**
     * 批量保存
     * @return
     */
    def saveList() {
        ResultJSON result = new ResultJSON(success: false,msg: '操作异常')
        try {
            String goodsList = params['goodsList']
            def saveList = []
            def categoryList =categoryService.getCategoryList()
//            def unitList = goodsUnitService.getGoodsUnitList()
            def goodses = goodsList.split(';')
            def branchId = LightConstants.getFromSession(session.id, SessionConstants.KEY_BRANCH_ID)?.asType(BigInteger)
            goodses?.each {
                def goods = new Goods()
                String[] p = it.split(',')
                int i = 0;
                goods.branchId = branchId

                goods.goodsName = StringUtils.trimToNull(p[i++])
                goods.categoryId = new BigInteger(StringUtils.trimToNull(p[i++]))
                goods.categoryName = this.getCategoryNameByCategoryId(goods.categoryId, categoryList)

                goods.goodsUnitId = new BigInteger(StringUtils.trimToNull(p[i++]))
//                goods.goodsUnitName = this.getGoodsUnitNameByGoodsUnitId(goods.goodsUnitId, unitList)

                def salePrice = StringUtils.trimToEmpty(p[i++])
                goods.salePrice = new BigDecimal((salePrice =~ /[0-9]+(.?[0-9]*)/).matches() ? salePrice : 0)

                def vipPrice = StringUtils.trimToEmpty(p[i++])
                goods.vipPrice1 = new BigDecimal((vipPrice =~ /[0-9]+(.?[0-9]*)/).matches() ? vipPrice : goods.salePrice)

                def vipPrice2 = StringUtils.trimToEmpty(p[i++])
                goods.vipPrice2 = new BigDecimal((vipPrice2 =~ /[0-9]+(.?[0-9]*)/).matches() ? vipPrice2 : goods.salePrice)

                goods.mnemonic = PinYinHelper.stringFirstLetter(StringUtils.trimToEmpty(goods.goodsName))
                goods.goodsStatus = 0
                goods.priceType = 0

                saveList << goods
            }
            result = goodsService.saveList(saveList)
//            if (result.jsonMap.isReload == "1"){
//                //加入是否刷新库存计算表
//                GoodsStoreList.setReload(1)
//            }
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            e.printStackTrace()
            LogUtil.logError(e, params)
        }
        render result
//        redirect action: 'index'
    }

    /**
     * 菜单编码生成
     * @return
     */
    def getNextGoodsCode() {
        BigInteger catId = params['catId']?.asType(BigInteger)
        def res = ''
        if (catId != null) {
            def gc = goodsService.getMaxGoodSCodeByTenantId(catId)
            if (!gc) {
                String code=categoryService.edit(catId.toString()).object.catCode;
                if(code&&code.length()==2){
                    gc = code + '000000'
                }else{
                    gc = code + '0000'
                }

            }
            res = SerialNumberGenerate.nextGoodsCode(gc)
        }
        render res
    }

    def getMnemonic(String barCode) {
        render PinYinHelper.stringFirstLetter(StringUtils.trimToEmpty(params.goodsCode))
    }
    def checkCode() {
        ResultJSON result
        try {
            result = goodsService.checkCode(params)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }
    /**
     * 新增
     */
    def create() {
        ResultJSON result
        try {
            String id = params.id;
            result = goodsService.getGoodsById(id)
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 修改
     */
    def update() {
        ResultJSON result = new ResultJSON(success: false,msg:  '操作异常')
        try {
            Goods goods = new Goods(params)
            goods.categoryName = this.getCategoryNameByCategoryId(goods.categoryId)
//            goods.goodsUnitName = this.getGoodsUnitNameByGoodsUnitId(goods.goodsUnitId)
            result = goodsService.updateGoods(goods)
//            if (result.jsonMap.isReload == "1"){
//                //加入是否刷新库存计算表
//                GoodsStoreList.setReload(1)
//            }
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        result.object = null
        render result
    }

    /**
     * 删除
     */
    def del() {
        ResultJSON result
        try {
            result = goodsService.delete(params)
//            if (result.jsonMap.isReload == "1"){
//                //加入是否刷新库存计算表
//                GoodsStoreList.setReload(1)
//            }
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 导出
     */
    def exportExcel() {
        ResultJSON result
        try {
            result = goodsService.queryGoodsList(params)
            List<Goods> exportGoods = result.jsonMap['rows'] as List<Goods>
            new WebXlsExporter().with {
                titles = ['菜品编码', '助记码', '菜品名称', '分类', '状态', '零售价', '会员价1', '会员价2']//, '可折扣', '可改价', '管理库存'
                sheetName = '菜品档案'
                setHeader(response, request, "菜品档案明细")
                doExport(response.outputStream, exportGoods) { List<SXSSFCell> cols, Goods goods ->
                    int c = 0;
                    cols[c++].setCellValue(goods.barCode)
                    cols[c++].setCellValue(StringUtils.trimToEmpty(goods.mnemonic))
                    cols[c++].setCellValue(goods.goodsName)
                    cols[c++].setCellValue(goods.categoryName)
                    def status
                    switch (goods.goodsStatus) {
                        case 0: status = '正常'; break
                        case 1: status = '停售'; break
                        case 2: status = '停购'; break
                        case 3: status = '淘汰'; break
                        default: status = ''
                    }
                    cols[c++].setCellValue(status)

                    DecimalFormat df = new DecimalFormat("0.00");
                    cols[c++].setCellValue(df.format(goods.salePrice.toDouble()))
                    cols[c++].setCellValue(df.format(goods.vipPrice1.toDouble()))
                    cols[c++].setCellValue(df.format(goods.vipPrice2.toDouble()))

//                    cols[c++].setCellValue(ParseUtils.parseString(goods.isForPoints))
//                    cols[c++].setCellValue(ParseUtils.parseString(goods.isRevisedPrice))
//                    cols[c].setCellValue(ParseUtils.parseString(goods.isStore))
                }
            }
            return
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            e.printStackTrace()
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 导入菜品
     */
    def importGoodsByExcel() {
        ResultJSON result
        try {
            InputStream inputStream = params['uploadFile'].getInputStream()
            List resList
            def branchId = LightConstants.getFromSession(session.id, SessionConstants.KEY_BRANCH_ID)?.asType(BigInteger)
            new WebXlsImporter<Goods>(inputStream).with {
                resList = getExcelToObject { jxl.Sheet sheet, int num ->
                    def rows = []
                    for (int i = 1; i <= num; i++) {
                        rows << i
                    }
                    def goodsList = []
                    rows.each {
                        def goods = new Goods()
                        goods.branchId = branchId

                        goods.goodsName = StringUtils.trimToNull(sheet.getCell(0, it).getContents())

                        goods.categoryName = StringUtils.trimToNull(sheet.getCell(1, it).getContents())
                        goods.categoryId = this.getCategoryIdByCategoryName(goods.categoryName)

//                        goods.goodsUnitName = StringUtils.trimToNull(sheet.getCell(2, it).getContents())
                        goods.goodsUnitId = this.getGoodsUnitIdByGoodsUnitName(goods.goodsUnitName)

                        def salePrice = StringUtils.trimToEmpty(sheet.getCell(3, it).getContents())
                        goods.salePrice = new BigDecimal((salePrice =~ /[0-9]+(.?[0-9]*)/).matches() ? salePrice : 0)

                        def vipPrice = StringUtils.trimToEmpty(sheet.getCell(4, it).getContents())
                        goods.vipPrice1 = new BigDecimal((vipPrice =~ /[0-9]+(.?[0-9]*)/).matches() ? vipPrice : goods.salePrice)

                        def vipPrice2 = StringUtils.trimToEmpty(sheet.getCell(5, it).getContents())
                        goods.vipPrice2 = new BigDecimal((vipPrice2 =~ /[0-9]+(.?[0-9]*)/).matches() ? vipPrice2 : goods.salePrice)

                        goods.mnemonic = PinYinHelper.stringFirstLetter(StringUtils.trimToEmpty(goods.goodsName))
                        goods.goodsStatus = 0
                        goods.priceType = 0
                        goodsList << goods
                    }
                    return goodsList
                }
            }
            result = goodsService.saveList(resList)
//            if (result.jsonMap.isReload == "1"){
//                //加入是否刷新库存计算表
//                GoodsStoreList.setReload(1)
//            }
            result.jsonMap = [:]
        } catch (ServiceException se) {
            LogUtil.logError(se, params)
        } catch (Exception e) {
            LogUtil.logError(e, params)
        }
        render result
    }

    /**
     * 获取模板
     * @return
     */
    def getExcelTemplate() {
        def type = []
        def unit = []
        categoryService.getNoChildCategoryList()?.each {
            type << it.catName
        }
        goodsUnitService.getGoodsUnitList()?.each {
            unit << it.unitName
        }
        new WebXlsTemplateExporter().with {
            setHeader(response, request, '菜品导入模板')
            title = ["商品名称",  '分类', '单位', '零售价', '会员价1', '会员价2'] as String[]
            listMap.put(1, type)
            listMap.put(2, unit)
            def name = ['商品 第1页'] as String[]
            doExport(response.getOutputStream(), name)
        }
    }

    /**
     * 上传文件
     * update hxh 2016-5-20
     * 直接写入共享目录，不通过拷贝
     */
    def upLoadFile() {
        ResultJSON json = new ResultJSON();

        String strBackUrl = "http://" + request.getServerName() + ":" + request.getServerPort() + "/" + request.getContextPath() + "/";
        String contextpath = request.getContextPath()
        MultipartFile imageFile = (MultipartFile) request.getFile("file");
        String imageType = imageFile.contentType
        if (imageType == "image/jpeg" || imageType == "image/gif" || imageType == "image/png" || imageType == "image/bmp") {
            int i = 1;
            long l = imageFile.size;
            if (l < i * 1024 * 1024) {
                String imageFileName = Common.nowCorrect2Millisecond + "" //+imageFile.getOriginalFilename();
                String imageCompreeName = "compree" + Common.nowCorrect2Millisecond + "" + imageFile.getOriginalFilename()
                String path = PropertyUtils.getDefault("picture_share_directory");
                //创建路径
                String filePath = path + "tenant/image/" + LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_ID)
                File targetImagePathFile = new File(filePath);
                if (!targetImagePathFile.exists()) {
                    targetImagePathFile.mkdirs();
                }
                LogUtil.logInfo("##servletContext.getRealPath=" + servletContext.getRealPath("/"))
                //创建文件
                File ImageFile = new File(filePath + "/" + imageFileName + "." + imageType.split("/")[1]);
                imageFile.transferTo(ImageFile);
                String imgpath = PropertyUtils.getDefault("goods_img_url")
                json.jsonMap.put("filePath", imgpath + "/tenant/image/" + LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_ID) + "/" + imageFileName + "." + imageType.split("/")[1]);
                json.jsonMap.put("dbpath", "/tenant/image/" + LightConstants.getFromSession(session.id, SessionConstants.KEY_TENANT_ID) + "/" + imageFileName + "." + imageType.split("/")[1]);
            } else {
                json.success = "false";
                json.msg = "上传图片大小不得超过1M！"
            }
        } else {
            json.success = "false";
            json.msg = "上传图片只能为jpg、gif、png、bmp格式！"
        }
        render json
    }
    /**
     * 菜品分类查询
     * @param Integer
     */
    private String getCategoryNameByCategoryId(BigInteger id, def list = categoryService.getCategoryList()) {
        def catId
        list?.each {
            if (it.id == id) {
                catId = it.catName; return
            }
        }
        return catId
    }

    /**
     * 菜品分类查询（根据名称）
     * @param Integer
     */
    private BigInteger getCategoryIdByCategoryName(String name, def list = categoryService.getCategoryList()) {
        def catName
        list?.each {
            if (it.catName == name) {
                catName = it.id; return
            }
        }
        return catName
    }

    /**
     * 菜品单位查询（根据名称）
     * @param name
     * @return
     */
    private BigInteger getGoodsUnitIdByGoodsUnitName(String name, def list = goodsUnitService.getGoodsUnitList()) {
        def unId
        list?.each {
            if (it.unitName == name) {
                unId = it.id; return
            }
        }
        return unId
    }

    /**
     * 菜品单位查询
     * @param id
     * @return
     */
    private String getGoodsUnitNameByGoodsUnitId(BigInteger id, def list = goodsUnitService.getGoodsUnitList()) {
        def unName
        list?.each {
            if (it.id == id) {
                unName = it.unitName; return
            }
        }
        return unName
    }

    /**
     * 打开新建菜品页
     */
    def openAddGoodView() {
        render(view: "addGood")
    }

    /**
     * 测试
     */
    def testPdf() {
        def result = goodsService.queryGoodsList(params)
        def exportGoods = result.jsonMap['rows']
        String path = servletContext.getRealPath("/");
        def pdf = new PdfUtils(path + 'trueType/simsun.ttc')
        new WebPdfExporter().with {

            setHeader(response, request, 'pdf哈哈')
            doExport(response.outputStream)
            setPdfAttributes()
            document.open()
            document.add(new Paragraph("菜品列表", pdf.defaultFont()));
            def title = ['序号', '菜品名称', '菜品编码'] as String []
            def table = pdf.defaultTable(title) { PdfPTable table ->
                exportGoods.eachWithIndex { Goods goods, int i ->
                    table.addCell(i.toString())
                    table.addCell(new Paragraph(goods.goodsName, pdf.defaultFont()))
                    table.addCell(new Paragraph(goods.barCode, pdf.defaultFont()))
                }
            }
            document.add(table)
            document.close()
        }
    }

    /**
     * 添加菜品
     */
    def addGoodsView() {
        def isStore = params['isStore']
        def isHavePackage = params['isHavePackage']
        def isHaveMaterial = params['isHaveMaterial']
        def singleSelect = params['singleSelect'] ? true : false
        render view: 'addGoodsStore',model: [isStore:isStore,isHavePackage:isHavePackage,isHaveMaterial:isHaveMaterial,singleSelect:singleSelect]
    }
    def queryDemo(){
        Goods goods=new Goods()
        goods.teststr="test"
        goods.goodsName="商品名称"
//        def jsonobj=[goodstest:goods.teststr,name:goods.goodsName]
//        def jsonobj=goods;

//            def homeAddress = new Goods(
//                    teststr: "25",
//                    goodsName: "High Street"
//            )
//
//            def result = [address: homeAddress]
//            render result as JSON
        def result=[rows:goods]
        render  result as JSON
    }

}
