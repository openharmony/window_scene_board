import fs from '@ohos.file.fs';
import { image } from '@kit.ImageKit';
import { display } from '@kit.ArkUI';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import { common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { JSON } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { dataSharePredicates } from '@kit.ArkData';
import { LogUtil } from '@ohos/lottie';

const MY_FILENME = 'my_wallpaper_'
const JSON_FILE_NAME = 'wallpaper_data.json';
export class ImageUtils {
  private dataList: string[] = []

  public static async convertUriToPixelMap(uri: string): Promise<image.PixelMap> {
    try {
      const file = await fs.open(uri, fs.OpenMode.READ_ONLY);
      const imageSource = image.createImageSource(file.fd);
      const decodingOptions: image.DecodingOptions = {
        //desiredSize: { width: display.getDefaultDisplaySync().width, height: display.getDefaultDisplaySync().height },
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      };
      const pixelMap: image.PixelMap = await imageSource.createPixelMap(decodingOptions);
      imageSource.release();
      fs.close(file);
      return pixelMap
    } catch (error) {
      Log.error('error: ', error);
      return error
    }
  }

  /**
   * 保存默认壁纸到沙盒
   * */
  public static async saveResourceToSandbox(
    context: common.UIAbilityContext
  ): Promise<string> {
    const fileName = 'wallpaperdefault.jpeg'
    try {
      // 1. 获取ResourceManager和resourceId（核心：media资源通过resourceId访问）
      const resourceMgr = context.resourceManager;
      const resource = $r(`app.media.wallpaperdefault`); // 生成Resource对象
      if (!resource || !resource.id) {
        throw new Error(`未找到media资源：`);
      }
      // 2. 打开Resource输入流，读取二进制数据
      const inputStream = await resourceMgr.getMediaContent(resource.id); // 同步读取
      // 3. 拼接沙盒目标路径
      const sandboxDir = context.filesDir; // Stage模型；FA模型用 context.getFilesDir()
      const targetPath = `${sandboxDir}/${MY_FILENME}${fileName}`;
      const isContain = await ImageUtils.isContainFile(context, `${MY_FILENME}${fileName}`)
      if (isContain) {
        return targetPath
      }
      // 4. 打开沙盒文件（CREATE=创建，WRITE_ONLY=只写，TRUNC=覆盖已有文件）
      const fileFd = fs.openSync(
        targetPath,
        fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY | fs.OpenMode.TRUNC,
      );
      fs.writeSync(fileFd.fd, inputStream.buffer);
      fs.closeSync(fileFd.fd);
      return targetPath;
    } catch (err) {
      const error = err as BusinessError;
      return '';
    }
  }


  /**
   * 保存图片到沙箱（同名文件直接覆盖）
   */
  public static async saveImage(sourceUri: string, context: common.UIAbilityContext): Promise<string> {
    // 获取原文件名
    const fileName = sourceUri.split('/').pop() || 'image.jpg';
    // 拼接目标路径
    const sandboxDir = context.filesDir; // 获取沙箱文件目录;
    let targetPath = ImageUtils.joinPath(sandboxDir, `${fileName}`);
    if (!fileName.includes(MY_FILENME)) {
      targetPath = ImageUtils.joinPath(sandboxDir, `${MY_FILENME}${fileName}`);
      ImageUtils.deleteFileIfExists(targetPath);
    }
    const realName = sourceUri.split('/').pop() || 'image.jpg';
    const isContain: boolean = await ImageUtils.isContainFile(context, realName)
    if (sourceUri.startsWith('datashare://media/') || sourceUri.startsWith('file://media/') || isContain) {
      ImageUtils.copyFileWithPhoto(sourceUri, targetPath, context);
    } else {
      ImageUtils.copyFileWithFile(sourceUri, targetPath, context);
    }
    return targetPath;
  }

  /**
   *  查找沙箱中是否包含该文件
   */
  public static async isContainFile(context: common.UIAbilityContext, name: string): Promise<boolean> {
    const sandboxDir = context.filesDir;
    const imageList: string[] = [];

    try {
      // 获取所有文件
      const fileNames = fs.listFileSync(sandboxDir);
      // 筛选图片文件
      const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
      for (const fileName of fileNames) {
        const ext = fileName.toLowerCase().substring(fileName.lastIndexOf('.'));
        if (imageExtensions.includes(ext) && fileName.includes(name)) {
          return true
        }
      }
    } catch (error) {

    }

    return false;
  }

  // ==================== 私有辅助方法 ====================

  /**
   * 路径拼接（兼容不同操作系统）
   */
  private static joinPath(...parts: string[]): string {
    return parts
      .map((part, index) => {
        if (index === 0) return part.replace(/\/$/, '');
        return part.replace(/^\//, '').replace(/\/$/, '');
      })
      .join('/');
  }

  /**
   * 删除文件（如果存在）
   */
  private static deleteFileIfExists(filePath: string): void {
    try {
      fs.unlinkSync(filePath);
    } catch {
      // 文件不存在，忽略
    }
  }

  /**
   * 从文件夹复制文件
   * */
  private static async copyFileWithFile(sourceUri: string, targetPath: string, context: common.UIAbilityContext) {
    try {
      const sourceFile = fs.openSync(sourceUri, fs.OpenMode.READ_ONLY);
      const targetFile = fs.openSync(targetPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.copyFileSync(sourceFile.fd, targetFile.fd, 0);
      fs.closeSync(sourceFile);
      fs.closeSync(targetFile);
      LogUtil.info(`copyfile success: ${targetPath}`);
    } catch (err) {
      const error = err as BusinessError;
      LogUtil.error(`copyfile error: ${error.code}, ${error.message}`);
    }
  }

  /**
   * 从相册复制文件
   */
  private static async copyFileWithPhoto(sourceUri: string, targetPath: string, context: common.UIAbilityContext): Promise<void> {
    try {
      // 1. 通过 photoAccessHelper 读取媒体文件
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      const predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', sourceUri);
      // 查询时获取文件大小
      const fetchOptions: photoAccessHelper.FetchOptions = {
        predicates: predicates,
        fetchColumns: [
          photoAccessHelper.PhotoKeys.URI,
          photoAccessHelper.PhotoKeys.SIZE,
          photoAccessHelper.PhotoKeys.DISPLAY_NAME
        ]
      };
      const fetchResult = await phAccessHelper.getAssets(fetchOptions);
      if (fetchResult.getCount() === 0) {
      }
      const asset = await fetchResult.getFirstObject();
      // 获取文件大小
      let fileSize = asset.get(photoAccessHelper.PhotoKeys.SIZE) as number;

      // 如果无法从元数据获取大小，通过 fd 获取
      if (fileSize === 0 || fileSize === undefined) {
        const fd = await asset.open('r');
        const stat = fs.statSync(fd);
        fileSize = stat.size;
        fs.closeSync(fd);
      }
      console.info(`file size: ${fileSize}`);
      // 2. 读取文件内容
      const fd = await asset.open('r');
      const arrayBuffer = new ArrayBuffer(fileSize);
      const readLen = fs.readSync(fd, arrayBuffer);
      // 关闭源文件
      fs.closeSync(fd);
      fetchResult.close();

      // 打开目标文件（如果不存在会创建，存在则覆盖）
      const saveFile = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      // 写入数据
      const writeLen = fs.writeSync(saveFile.fd, arrayBuffer);
      // 关闭目标文件
      fs.closeSync(saveFile);
    } catch (error) {
    }
  }

  public static async readLocalImage(imagePath: string): Promise<PixelMap | null> {
    try {
      const file = fs.openSync(imagePath, fs.OpenMode.READ_ONLY)
      const stat = fs.statSync(imagePath)
      const fileSize = stat.size
      const buffer = new ArrayBuffer(fileSize)
      fs.readSync(file.fd, buffer)
      fs.close(file)
      const imageSource = image.createImageSource(buffer)
      // 2. 创建PixelMap
      const pixelMap = await imageSource.createPixelMap();
      imageSource.release();
      return pixelMap
    } catch (error) {
      const err = error as BusinessError;
      return null;
    }
  }

  //
  /**
   * 初始化 JSON 文件
   */
  public static async initJsonFile(context: common.UIAbilityContext): Promise<string> {
    try {
      // 1. 检查文件是否存在
      const sandboxDir  = context.filesDir;
      const targetPath = `${sandboxDir}/${JSON_FILE_NAME}`;
      const fileExists = await ImageUtils.checkFileExists(targetPath);

      if (!fileExists) {
        // 2. 文件不存在，创建并初始化
         await ImageUtils.createJsonFile(targetPath, []);
      } else {
        // 3. 文件存在，读取数据
        await ImageUtils.readJsonFile(targetPath);
      }
      return targetPath
    } catch (error) {
       return ""
    }
  }

  /**
   * 检查文件是否存在
   */
  public static async checkFileExists(filePath: string): Promise<boolean> {
    try {
      await fs.access(filePath);
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * 创建 JSON 文件
   */
  public static async createJsonFile(jsonPath: string, initialData: string[]): Promise<void> {
    try {
      const jsonString = JSON.stringify(initialData, null, 2);
      const file = fs.openSync(jsonPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(file.fd, jsonString);
      fs.closeSync(file);
    } catch (error) {
      const err = error as BusinessError;
    }
  }

  /**
   * 读取 JSON 文件
   */
  public static async readJsonFile(jsonPath: string): Promise<string[]> {
    try {
      const file = fs.openSync(jsonPath, fs.OpenMode.READ_ONLY);
      const stat = await fs.stat(jsonPath);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);

      const uint8Array = new Uint8Array(buffer);
      let jsonString = '';
      for (let i = 0; i < uint8Array.length; i++) {
        jsonString += String.fromCharCode(uint8Array[i]);
      }
      const data = JSON.parse(jsonString) as string[];
      fs.closeSync(file);
      return data
    } catch (error) {
      return []
    }
  }

  /**
   * 写入 JSON 文件
   */
  public static async writeJsonFile(jsonPath: string, data: string[]): Promise<void> {
    try {
      const jsonString = JSON.stringify(data, null, 2);
      const file = fs.openSync(jsonPath, fs.OpenMode.CREATE | fs.OpenMode.TRUNC | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(file.fd, jsonString);
      fs.closeSync(file);
    } catch (error) {
      const err = error as BusinessError;
     }
  }

  /**
   * 添加数据
   */
  public static async addData(jsonPath: string, data: string[], newItem: string) {
    let dataList = data
    if (dataList.length === 0) {
      dataList.push(newItem)
    } else {
      dataList = dataList.filter((data) => data !== newItem)
      dataList.splice(0, 0, newItem)
    }
    await ImageUtils.writeJsonFile(jsonPath, dataList);
  }

  /**
   * 首次进入，默认添加默认主题壁纸
   * */
  public static async addDefaultData(jsonPath: string, data: string[], newItem: string) {
    let dataList = data
    dataList.push(newItem)
    await ImageUtils.writeJsonFile(jsonPath, dataList);
  }

}