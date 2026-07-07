/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  FileFolderManager,
  RefreshUriListener,
  RightMenuNewFileData,
  FileSuffix,
  FileFolderService,
  DesktopItemPosition,
  FileShortCutDesktopAction,
  FileExistResult,
  FileFolderInfo,
  MenuClickModel,
  FileFolderStyleConstants,
  MenuConstants,
} from '@ohos/desktopfilefolder';
import {
  CommonConstants,
  DesktopFileInfo,
  EventConstants,
  FileType,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  MenuInfo,
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain,
  LogHelper,
  ObjUtil,
  RectInfo,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  FileChangeEvent,
  GlobalContext,
  localEventManager,
  ScreenLockEvent,
  HiSysEventUtil,
  DeviceHelper,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import { DisplayConstants } from '@ohos/windowscene';
import { StartType } from '@ohos/basicutils';
import {
  DragGridPosition,
  DragPosition,
} from '@ohos/componentdrag';
import { ItemUtils } from '@ohos/componenthelper';
import { PcFileFolderConstants } from '../constants/PcFileFolderConstants';
import context from '@ohos.app.ability.common';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import HashSet from '@ohos.util.HashSet';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import PcFileAccess, { FileEventAction, FileEventStatus, FileObservedChangeEvent } from './PcFileAccess';
import Prompt from '@ohos.promptAction';
import UDC from '@ohos.data.unifiedDataChannel';
import systemParameter from '@ohos.systemparameter';
import common from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import { preferences } from '@kit.ArkData';
import { bundleResourceManager, wantConstant } from '@kit.AbilityKit';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import fileInfoUpdateManager from '@ohos/desktopfilefolder/src/main/ets/default/FileInfoUpdateManager';
import type ctx from '@ohos.app.ability.common';
import deviceInfo from '@ohos.deviceInfo';
import { ExtraData } from '@ohos/desktopfilefolder/src/main/ets/default/common/FileFolderConstants';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { DialogController, DialogControllerType } from '@ohos/launchercommon/src/main/ets/viewmodel/DialogController';
import { DesktopLayoutManager } from '@ohos/pagedesktop/src/main/ets/default/manager/DesktopLayoutManager';
import { ItemParameter } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import ScreenLockService from '../../SceneBoard/screenlock/refactor/ScreenLockService';
import { PCDockUtils } from '@ohos/pcsmartdock/src/main/ets/default/utils/PCDockUtils';
import { display } from '@kit.ArkUI';
import FeatureConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/FeatureConstants';
import {
  SCBSceneSessionManager,
  SCBSystemSceneSession,
  SystemBarType,
} from '@ohos/windowscene';

const TAG: string = 'PcFileFolderManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_MIN_WIDTH: number = 159;
const INVALID_VALUE: number = -1;
const RIGHT_MENU_SUFFIX: number = 62;
const MAX_RETRY_TIMES: number = 5;
const RETRY_DURING: number = 200;
const NOTIFY_DELAY: number = 50;
const MIN_NEED_SORT_LEN: number = 2;
const PREFERENCES_OPTIONS: preferences.Options = { name: 'filePreferences' };
const FILEMANAGER_BUNDLE_NAME: string = 'com.ohos.filemanager';
const ENTERPRISE_SPACE_ENABLE: string = 'persist.space_mgr_service.enterprise_space_enable';
const DELAY_REFRESH_RECYCLEBIN: number = 2000;
let dragToSnapshotDelayTimer: number | null = null;

enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

enum FileManagerWindowAction {
  ENTER_RECYCLE_BIN = 0,
  LEAVE_RECYCLE_BIN = 1
}

function setUdmfData(item: GridLayoutItemInfo): UDC.UnifiedRecord {
  let result: UDC.UnifiedRecord = new UDC.UnifiedRecord();
  switch (item.typeId) {
    case CommonConstants.TYPE_APP:
    case CommonConstants.TYPE_SHORTCUT_ICON:
      let appItem = new UDC.SystemDefinedAppItem();
      appItem.appId = String(item?.id);
      appItem.appName = item?.appName ?? '';
      appItem.appIconId = String(item?.appIconId);
      appItem.appLabelId = String(item?.appLabelId);
      appItem.bundleName = item?.bundleName;
      appItem.abilityName = item?.abilityName;
      result = appItem as UDC.UnifiedRecord;
      break;
    case CommonConstants.TYPE_FILE_FOLDER:
      // result = UdmfUtils.setUnifiedData(CommonUtil.getFileInfosFromUris([item?.uri])[0]) as UDC.UnifiedRecord;
      break;
    default:
      break;
  }
  return result;
}



export default class PcFileFolderManager extends FileFolderManager {
  public static singleName: string = 'PcFileFolderManager';
  // all files on desktop
  private hasRegisteredFileChange: boolean = false;
  private isFoldersRegistered: boolean = false;
  private static instance: PcFileFolderManager;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private firstLoaded: boolean = false;
  private rightMenuMinWidth: number = DEFAULT_MIN_WIDTH;
  private refreshUriListeners: Map<string, RefreshUriListener> = new Map();
  private registeredFolders: Map<string, DesktopFileInfo> = new Map();
  // private rightMenuExpandManager: RightMenuExpandManager = RightMenuExpandManager.getInstance();
  private unlockRetryTimes: number = 0;
  private notifyTimeoutId: number = CommonConstants.INVALID_VALUE;
  private filePreferences: preferences.Preferences | null = null;
  private context: context.UIAbilityContext | undefined = undefined;
  private newFile: DesktopFileInfo | null = null;
  private rightClickPosition: DragPosition | null = null;
  private recycleBinWindowIdList: number[] = [];
  private deviseSN: string = '';
  private uris: Map<string, number[]> = new Map<string, number[]>();
  private menuIconCache: Map<string, Resource | PixelMap> = new Map();
  private isMenuShow: boolean = false;
  private isTimeOut: boolean = false;
  private fileCallbackMap: Map<number, Function> = new Map<number, Function>();
  private fileChangeCallbackMap: Map<string, Function> = new Map();
  private curFileInfoList: ESObject[] = [];
  private fileImgSrc: string = '';
  private isExtensionSuffix: boolean = true;

  constructor(ctx?: SingleContext) {
    super(ctx);
    try {
      // this.rightMenuExpandManager.getAllRightMenuInfo();
      this.eventMgr.on(ScreenLockEvent, (event: ScreenLockEvent) => this.handleUnLockEvent(event));
      this.context = GlobalContext.getInstance().getObject('desktopContext') as context.UIAbilityContext;
      this.context?.eventHub.on('dropToTrash', ((uris: string[]) => {
        this.notifyDesktopFileDrop(uris, false);
      }));
      this.filePreferences = preferences.getPreferencesSync(this.context, PREFERENCES_OPTIONS);
      this.isExtensionSuffix = this.filePreferences.getSync('isExtensionSuffix', true) as boolean;
      AppStorage.setOrCreate<boolean>('isExtensionSuffix', this.isExtensionSuffix);
      this.deviseSN = deviceInfo.serial;
      log.showInfo(`filePreferences get isExtensionSuffix: ${this.isExtensionSuffix}`);
      PcFileAccess.registerIconChangeListener(
        (utdTypeID: string[]) => fileInfoUpdateManager.dispatchFileIconUpdateByUtdType(utdTypeID));
    } catch (err) {
      log.showError(`PcFileFolderManager constructor error, code: ${err?.code}, message: ${err?.message}`);
    }
    this.menuIconCache.clear();
    this.fileImgSrc = this.getApplicationIcon(FILEMANAGER_BUNDLE_NAME);
  }

  static getInstance(ctx?: SingleContext): PcFileFolderManager {
    return singleManager.get<PcFileFolderManager>(PcFileFolderManager, ctx);
  }

  public getUtdTypeByFileName(fileName: string): string {
    const suffix = this.getFileExtensionByName(fileName);
    return PcFileAccess.getUtdTypeBySuffix(suffix);
  }
  /**
   *
   * 系统语言变化时，刷新引用har包中的文字
   * @returns
   */
  public languageChangeRefresh(): void {
    // RightMenuExpandManager.languageChangeRefresh();
  }

  /**
 *
 * 从文件系统查询当前桌面路径下所有文件，并刷新桌面
 *
 * @param firstRefresh 是否首次刷新
 * @returns
   */
  async refreshDesktopFiles(firstRefresh: boolean = false): Promise<void> {
    let desktopUri = await PcFileAccess.getDesktop();
    log.showInfo(`refreshDesktopFiles, firstRefresh:${firstRefresh}`);
    PcFileAccess.listFilesOfFolder(desktopUri, (resultArray: ESObject[]) => {
      log.showInfo(`refreshDesktopFiles resultArray: ${resultArray?.length}`);
      this.handleFileInfoList(resultArray);
      if (firstRefresh) {
        log.showInfo('refreshDesktopFiles firstRefresh');
        // CommonUtil.init(this.context, 'DesktopFile');
        setTimeout(() => {
          this.registerRecycleBinListenerFileAccess();
        }, 1000);
        this.firstLoaded = true;
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH, '');
      }
    })
  }

  private handleFileInfoList(fileInfoList: ESObject[]) {
    log.showInfo(`handleFileInfoList fileInfoList: ${fileInfoList?.length}`);
    this.sortFilesByCreatedTime(fileInfoList);
    let desktopFileArrays: DesktopFileInfo[] = [];
    this.curFileInfoList = fileInfoList;
    for (let index = 0; index < fileInfoList.length; index++) {
      let resultFileInfo: ESObject = fileInfoList[index];
      let desktopFile: DesktopFileInfo = {
        uri: resultFileInfo.uri,
        fileName: resultFileInfo.fileName,
        thumbnail: this.getThumbnail(resultFileInfo),
        ino: resultFileInfo.ino,
        fileType: this.getFileType(resultFileInfo),
        mtime: resultFileInfo.mtime,
        size: resultFileInfo.size,
        ctime: resultFileInfo.ctime
      }
      if (this.uris.size > 0 && this.uris.has(resultFileInfo.uri)) {
        let colAndRow: number[] | undefined = this.uris.get(resultFileInfo.uri);
        log.showInfo(`refreshDesktopFiles, colAndRow:${colAndRow}, ino:${desktopFile.ino}`);
        if (colAndRow) {
          desktopFile.row = colAndRow[1];
          desktopFile.column = colAndRow[0];
          if (colAndRow.length > 2) {
            desktopFile.page = colAndRow[2];
          }
        }
        this.uris.delete(resultFileInfo.uri);
      }
      log.showInfo(`refreshDesktopFiles index: ${index}, ino: ${desktopFile?.ino}, appiconId: ${desktopFile?.thumbnail},` +
        ` mtime: ${desktopFile?.mtime}, size: ${desktopFile?.size}, ctime: ${desktopFile?.ctime},row:${desktopFile?.row}` +
        `column:${desktopFile?.column},page: ${desktopFile?.page}`);
      desktopFileArrays.push(desktopFile);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH, desktopFileArrays);
    if (this.isFoldersRegistered) {
      this.refreshFoldersListener(desktopFileArrays);
    }
    this.registerFileChange();
  }


  /**
   * 降序比较两个文件的创建日期，如果创建日期相同则降序比较名称，如果名称相同则降序比较大小;
   * @param resultArray
   * @returns
   */
  private sortFilesByCreatedTime(resultArray: ESObject[]): ESObject[] {
    if (resultArray.length < MIN_NEED_SORT_LEN) {
      return resultArray;
    }
    let newFileItems: ESObject[] = resultArray;
    newFileItems.sort((item1: ESObject, item2: ESObject) => {
      if (!item1 || !item2) {
        log.showWarn('sortItemsByCreatedTime compareFile failure as item is null');
        return 0;
      }
      let timeGap: number = item2.ctime - item1.ctime;
      let compareRes: number = timeGap;
      if (compareRes === 0) {
        let nameGap: number = item2.fileName?.localeCompare(item1.fileName, 'zh');
        compareRes = (nameGap === 0 ? (item1.size - item2.size) : nameGap);
      }
      return compareRes;
    });
    return newFileItems;
  }

  /**
   * 打开文件或文件夹
   * @param uri 文件uri
   * @param context
   */
  public async openFileOrFolder(uri: string): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(uri)) {
      log.showInfo('empty uri, cant open fileFolder');
      return;
    }
    PcFileAccess.openFile(uri);
  }

  public getFileFolderPosition(column?: number, row?: number, page?: number): DragGridPosition | null {
    const layoutManager = DesktopLayoutManager.getDesktopLayoutManager();
    if (!layoutManager) {
      log.showWarn('layoutViewModel is null');
      return null;
    }
    log.showInfo(`getFileFolderPosition:${column}, ${row}, ${page}`);
    let filePosition: DragGridPosition | null = null;
    page = page ?? 0;
    if (row !== undefined && column !== undefined && layoutManager.isAvailablePosition(column, row, page)) {
      filePosition = { row: row, column: column, page: page };
    }
    if (!filePosition) {
      const area : ItemParameter = { area: [1, 1] };
      filePosition = layoutManager.getItemPositionInScreen(area, page ?? 0);
    }
    return filePosition;
  }

  /**
   * 构造右键新建文件右键菜单项
   * @param subMenuInfo 菜单项
   */
  public pushDefaultBlankFile(subMenuInfo: MenuInfo[]): void {
    if (!subMenuInfo) {
      log.showError('pushDefaultBlankFile failed, subMenuInfo invalid');
      return;
    }
    let newFileDataArray: ESObject[] = PcFileAccess.getNewFileSupportList();
    newFileDataArray.forEach((item:ESObject) => {
      let createSubFolder = new MenuInfo();
      createSubFolder.menuText = item?.menuName;
      createSubFolder.bundleName = item?.bundleName;
      createSubFolder.menuKeyString = item?.menuName;
      createSubFolder.menuImgSrc = this.parseMenuIcon(item);
      createSubFolder.onMenuClick = (column?: number, row?: number, pageId?: number) => {
        const filePosition = this.getFileFolderPosition(column, row, pageId);
        if (!filePosition) {
          HiSysEventUtil.reportFullContinueAdding(DisplayConstants.DEFAULT_DISPLAY);
          Prompt.showToast({
            message: $r('app.string.add_icon_to_desktop_max'),
            bottom: PageDesktopViewModel.getInstance(this.singleContext).getToastBottom()
          });
          return;
        }
        const newFileColumn = filePosition.column;
        const newFileRow = filePosition.row;
        let dirUri = this.createNewBlankFile(item);
        let uris: Map<string, number[]> = new Map<string, number[]>();
        let colAndRow: number[] = filePosition.page === undefined ?
          [newFileColumn, newFileRow] : [newFileColumn, newFileRow, filePosition.page];
        uris.set(dirUri, colAndRow)
        this.createNewFile(uris);
        this.refreshDesktopFiles();
        log.showInfo('create blank file folder end');
      };
      subMenuInfo.push(createSubFolder);
    })
  }

  /**
   * 构造分区文件夹的右键新建文件右键菜单项
   * @param subMenuInfo 菜单项
   */
  public pushDefaultBlankFileAtRegionFolder(subMenuInfo: MenuInfo[]): void {
    if (!subMenuInfo) {
      log.showError('pushDefaultBlankFile failed, subMenuInfo invalid');
      return;
    }
    let newFileDataArray: ESObject[] = PcFileAccess.getNewFileSupportList();
    newFileDataArray.forEach((item:ESObject) => {
      let createSubFolder = new MenuInfo();
      createSubFolder.menuText = item?.menuName;
      createSubFolder.bundleName = item?.bundleName;
      createSubFolder.menuKeyString = item?.menuName;
      createSubFolder.menuImgSrc = this.parseMenuIcon(item);
      createSubFolder.onMenuClick = (column?: number, row?: number, page?: number, target?: GridLayoutItemInfo) => {
        if (!target) {
          log.showError('right_create_file fail, target is null');
          return;
        }
        this.createNewBlankFile(item, target.uri);
        this.refreshDesktopFiles();
        log.showInfo('create blank file end');
      };
      subMenuInfo.push(createSubFolder);
    })
  }

  private parseMenuIcon(menuInfo: ESObject): Resource | PixelMap {
    const cacheKey: string = menuInfo.bundleName + menuInfo.moduleName + menuInfo.iconPath + menuInfo.fileSuffix;
    let menuIcon: Resource | PixelMap | undefined = this.menuIconCache.get(cacheKey);
    if (menuIcon) {
      return menuIcon;
    }
    menuIcon = PcFileAccess.parseMenuIcon(menuInfo);
    if (!menuIcon) {
      menuIcon = this.getDefaultImage(false, menuInfo.fileSuffix);
    }
    this.menuIconCache.set(cacheKey, menuIcon);
    return menuIcon;
  }

  /**
   * 新建空白文件
   * @param item 新建文件菜单参数
   */
  private createNewBlankFile(newFileData: ESObject, uri?: string): string {
    if (!uri) {
      uri = PcFileAccess.desktopPath;
    }
    /*let res : string | BusinessError = RightMenuViewUtils.buildNewFile(uri, newFileData);
    if (res instanceof Error) {
      log.showError(`createNewBlankFile error, message: ${res.message}, stack: ${res.stack}`);
      return '';
    }
    AppStorage.setOrCreate<string>('newCreateFolder', res as string);
    return res;*/
    return '';
  }

  private getFileFoldersByUris(uris: string[]): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(uris)) {
      log.showInfo('getFileFolderByUri, uris is empty');
      return [];
    }
    const layoutItems = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList();
    const fileFolders: GridLayoutItemInfo[] = layoutItems.filter(item => {
      if (item.uri && uris.includes(item.uri)) {
        return true;
      }
      return false;
    });
    return fileFolders;
  }

  private setDialogDefaultPosition(uris: string[]): void {
    const isShowBSide = this.getFileFoldersByUris(uris).some(item => item.page === 0);
    const dialogController = DialogController.getDialogController(DialogControllerType.DESKTOP_FILE_FOLDER);
    dialogController?.setDialogShowPage(isShowBSide ? 0 : 1);
  }

  /**
   * 删除文件或文件夹
   * @param uris 待删除文件或文件夹路径
   * @param isForceDelete 是否强制删除
   */
  async deleteFileOrFolder(uris: string[], isForceDelete: boolean = false,
    isRegisterHistory: boolean = true): Promise<void> {
    log.showInfo('deleteFileOrFolder');
    if (ObjUtil.isInvalid(uris)) {
      log.showInfo('deleteFileOrFolder uris is null');
      return;
    }
    this.setDialogDefaultPosition(uris);
    /*uris.forEach((element: string) => {
      HiSysEventUtil.reportCompletelyDelete(DisplayConstants.DEFAULT_DISPLAY,
        this.getFileType(FileInfo.fromFileUriDesktop(element)));
    });*/
    PcFileAccess.delete(uris, isForceDelete, isRegisterHistory);
    PageDesktopViewModel.getInstance(this.singleContext).setCutStatusChange([], false);
  }

  /**
   * 复制文件
   * @param 待复制文件列表
   */
  copyFiles(uris: string[]): void {
    log.showInfo('copyFiles:' + uris?.length);
    PcFileAccess.copyFile(uris);
  }

  /**
   * 剪切文件
   * @param uris 待剪切文件uri列表
   */
  cutFiles(uris: string[]): void {
    log.showInfo('cutFiles:' + uris?.length);
    PcFileAccess.cutFile(uris);
  }

  /**
   * 清空剪切板
   */
  public clearPasteboard(): void {
    PcFileAccess.clearPasteboard();
  }

  /**
   * 粘贴文件
   */
  async pasteFiles(destUri?: string, isShortCut?: boolean): Promise<void> {
    destUri = destUri ? destUri : await PcFileAccess.getDesktop();
    await PcFileAccess.pasteFile(destUri, isShortCut);
    PageDesktopViewModel.getInstance(this.singleContext).setCutStatusChange([], false);
  }

  /**
   * 粘贴快捷方式
   * @param destinationUri
   * @returns
   */
  public async pasteShortcut(destinationUri?: string): Promise<void> {
    destinationUri = destinationUri ? destinationUri : await PcFileAccess.getDesktop();
    await PcFileAccess.pasteFile(destinationUri, true);
  }

  /**
   * 新建文件夹
   * @param callback 新建结果回调
   */
  async createNewFolder(uri?: string, isRegisterHistory: boolean = true): Promise<string | BusinessError<void>> {
    log.showInfo('createNewFolder');
    if (!uri) {
      uri = await PcFileAccess.getDesktop();
    }
    return await PcFileAccess.mkDir(uri, isRegisterHistory);
  }

  /**
   * 新建文件夹，给定行列数
   */
  createNewFile(uris: Map<string, number[]>): void {
    log.showInfo(`createNewFile:${uris.size}`);
    this.uris = uris;
  }

  /**
   * 重命名文件
   * @param uri 文件uri
   * @param name 文件名
   * @param isShowSuffix 是否处于显示后缀名状态
   * @returns
   */
  async rename(uri: string, name: string, isShowSuffix?: boolean): Promise<string> {
    log.showInfo('rename file');
    this.setDialogDefaultPosition([uri]);
    return await PcFileAccess.rename(uri, name, isShowSuffix);
  }

  public async renameNoCheckNoHistory(srcUri: string, fileName: string): Promise<string> {
    return await PcFileAccess.renameNoCheckNoHistory(srcUri, fileName);
  }

  /**
   * 通过文件uri获取文件信息
   * @param uri 文件uri
   * @returns
   */
  public getFileInfoByUri(uri?: string): FileFolderInfo | undefined {
    if (!uri || uri === '') {
      log.showWarn('getFileInfoByUri, file uri is null');
      return undefined;
    }
    let fileInfo: ESObject | undefined = undefined;
    try {
      // fileInfo = FileInfo.fromFileUri(uri);
    } catch (error) {
      log.showError(`getFileInfoByUri error, ${error?.code}, ${error?.message}`);
      return undefined;
    }
    if (!fileInfo) {
      log.showWarn('getFileInfoByUri, file is not exist');
      return undefined;
    }
    const fileFolderInfo = new FileFolderInfo(fileInfo.uri);
    fileFolderInfo.ino = fileInfo.ino;
    fileFolderInfo.fileName = fileInfo.fileName;
    fileFolderInfo.mtime = fileInfo.mtime;
    fileFolderInfo.mtimeMs = fileInfo.mtimeMs;
    fileFolderInfo.ctime = fileInfo.ctime;
    fileFolderInfo.fileType = this.getFileType(fileInfo);
    fileFolderInfo.thumbnail = this.getThumbnail(fileInfo);
    return fileFolderInfo;
  }

  /**
   * 判断文件是否是Video类型
   * @param uri 文件uri
   * @returns
   */
  public isVideoThumbnailType(uri?: string): boolean {
    if (!uri) {
      log.showError(`isVideoThumbnailType uri is empty`);
      return false;
    }
    let result: boolean = false;
    /*const fileInfo: FileInfo = FileInfo.fromFileUri(uri);
    if (!fileInfo) {
      return result;
    }*/
    // result = (fileInfo.thumbnailType === ThumbnailUtil.VIDEO_TYPE);
    log.showInfo(`isVideoThumbnailType ${result}`);
    return result;
  }

  /**
   * 监听文件变化
   */
  private registerFileChange(): void {
    log.showInfo('registerFileChange');
    if (this.hasRegisteredFileChange) {
      return;
    }
    PcFileAccess.getDesktop().then((desktopUri: string) => {
      if (!PcFileAccess.isFileExists(desktopUri)) {
        log.showWarn('registerFileChange desktop path not ready now');
        return;
      }
      PcFileAccess.listenFolder(PcFileAccess.desktopPath, this.onDesktopFileChange.bind(this));
      this.registerFolders(desktopUri);
      this.subscribeFileItemStateChanged();
      this.refreshDesktopFiles(true);
      this.hasRegisteredFileChange = true;
      log.showInfo('registerFileChange success');
    });
  }

  /**
   * 是否支持文件特性
   * @returns true: 支持, false: 不支持
   */
  public isSupportDesktopFile(): boolean {
    return PcFileFolderConstants.isSupportDesktopFile;
  }

  /**
   * 是否首次加载
   * @returns
   */
  public isFilesFirstLoaded(): boolean {
    return this.firstLoaded;
  }

  /**
   * 刷新注册uri，待缩略图方案上线后，此处废弃
   * @param ino 文件ino
   * @param listener 刷新监听器
   */
  public registerRefreshUri(ino: string, listener: RefreshUriListener): void {
    if (!listener) {
      log.showError('registerRefreshUri failed, listener invalid');
      return;
    }
    if (this.refreshUriListeners.has(ino)) {
      log.showInfo(`registerRefreshUri, has registered, ino: ${ino}`);
      return;
    }
    this.refreshUriListeners.set(ino, listener);
    log.showInfo(`registerRefreshUri success. ino: ${ino}`);
  }

  /**
   * 文件删除时，解除注册
   * @param ino 文件ino
   */
  public unregisterRefreshUri(ino: string): void {
    if (!this.refreshUriListeners.has(ino)) {
      log.showWarn(`unregisterRefreshUri ino: ${ino} not exist.`);
      return;
    }
    this.refreshUriListeners.delete(ino);
  }

  /**
   * 获取桌面元素默认图标
   * @param isFolder, 是否文件夹
   * @param fileName, 文件名
   * @returns
   * @returns 图标资源
   */
  public getDefaultImage(isFolder: boolean, fileName: string): Resource {
    if (isFolder) {
      // return ThumbnailUtil.thumbnailMap.get(FileThumbnailType['folder']) as Resource;
    }
    let ret: PixelMap | string | Resource | null = this.getFileIconResource(fileName);
    if (!ret) {
      // 没查到对应类型，使用默认图标
      log.showInfo('getDefaultImage resource not exist: ');
      return $r('app.media.ic_normal_unknown');
    }
    return ret as Resource;
  }

  /**
   * 获取DLP小锁图标资源
   * @returns
   */
  public getDlpImage(): Resource {
    return $r('app.media.ic_normal_dlp');
  }

  /**
   * 获取文件夹图标资源
   * @returns
   */
  public getFolderIconResource(): Resource {
    // return ThumbnailUtil.thumbnailMap?.get(FileThumbnailType['empty_folder']) as Resource;
    return {} as Resource;
  }

  public getFileIconResource(fileName: string): PixelMap | string | Resource | null {
    let fileExtension: string = this.getFileExtensionByName(fileName);
    log.showInfo(`getFileIconResource: ${fileExtension}`);
    /*const ret: PixelMap | undefined = ThumbnailUtil.getThumbnailPixMapByUtdTypeId(fileExtension, this.context);
    if (!ret) {
      log.showWarn('getThumbnailPixMapByUtdTypeId ret is undefined');
      return $r('app.media.ic_normal_unknown');
    }
    return ret;*/
    return '';
  }

  /**
   * 获取右键菜单最小宽度
   * @returns 最小宽度值
   */
  public getRightMenuMinWidth(): number {
    return this.rightMenuMinWidth;
  }

  /**
   * 查询桌面文件右键菜单项
   * @param currentFile 当前选中的文件
   * @param selectFiles 所有被选中的文件
   * @returns
   */
  public getRightMenuInfo(currentFile: string | undefined, selectFiles: string[], page: number): MenuInfo[] {
    if (!currentFile) {
      log.showError(`getRightMenuInfo currentFile is empty`);
      return [];
    }
    log.showInfo(`getRightMenuInfo, selectFile length:${selectFiles.length}, page:${page}`);
    let menuInfoList: MenuInfo[] = [];
    let containsAppOnDesktop: boolean = PageDesktopViewModel.getInstance(this.singleContext).selectItemContainApp();
    if (containsAppOnDesktop) {
      this.rightMenuMinWidth = DEFAULT_MIN_WIDTH;
      let cMenuInfo: MenuInfo = new MenuInfo();
      cMenuInfo.menuText = $r('app.string.app_menu_open');
      cMenuInfo.menuKeyString = 'menu_open';
      cMenuInfo.onMenuClick = () => {
        PageDesktopViewModel.getInstance(this.singleContext).doEnterCurrentItemEvent(currentFile);
      }
      menuInfoList.push(cMenuInfo);

      let bMenuInfo: MenuInfo = new MenuInfo();
      bMenuInfo.menuText = '';
      bMenuInfo.menuKeyString = '-';
      menuInfoList.push(bMenuInfo);

      let mMenuInfo: MenuInfo = new MenuInfo();
      mMenuInfo.menuText = $r('app.string.accessibility_notification_delete_bar');
      mMenuInfo.menuKeyString = 'menu_delete';
      mMenuInfo.onMenuClick = () => {
        if (containsAppOnDesktop) {
          PageDesktopViewModel.getInstance(this.singleContext).doDeleteEvent();
        }
      }
      menuInfoList.push(mMenuInfo);
    }
    /*else {
      let rightMenuInfo: RightMenuInfo = new RightMenuInfo(
        FileInfo.fromFileUriDesktop(currentFile),
        selectFiles,
        selectFiles.indexOf(currentFile) > INVALID_VALUE,
        selectFiles.length > 1,
        UnityStartMode.DESKTOP_FILE_START
      );
      // 用所选文件新建回调，拉起新建后文件重命名文本框
      rightMenuInfo.callback = (uri: string) => {
        log.showInfo('the selected file is successfully created.');
        AppStorage.setOrCreate('renameFile', uri);
      }
      // 供给文管的坐标用于计算详情页面弹出位置
      let point: Point = new Point(
        this.rightClickPosition?.x ?? 0,
        this.rightClickPosition?.y ?? 0,
      );
      rightMenuInfo.detailPoint = point;
      let rightMenuGroup: ESObject[][] = [];
      let cMenuWidth: number = PcFileAccess.getShowMenuItem(rightMenuInfo, rightMenuGroup);
      const fontSizeScale =
        (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).config.fontSizeScale || 1;
      log.showInfo(`getRightMenuInfo MenuWidth: ${cMenuWidth}, fontSizeScale: ${fontSizeScale}`);
      if (cMenuWidth > DEFAULT_MIN_WIDTH) {
        cMenuWidth = cMenuWidth + RIGHT_MENU_SUFFIX * fontSizeScale;
      }
      this.rightMenuMinWidth = cMenuWidth > 0 ? cMenuWidth : this.rightMenuMinWidth;
      if (!rightMenuGroup) {
        return menuInfoList;
      }
      log.showInfo(`getRightMenuInfo length is: ${rightMenuGroup.length}`);
      for (let groupIndex = 0; groupIndex < rightMenuGroup.length; groupIndex++) {
        if (!rightMenuGroup[groupIndex]) {
          continue;
        }
        for (let itemIndex = 0; itemIndex < rightMenuGroup[groupIndex].length; itemIndex++) {
          let cMenuInfo: MenuInfo = new MenuInfo();
          let rMenuItem: ESObject = rightMenuGroup[groupIndex][itemIndex];
          if (!rMenuItem) {
            log.showWarn('getRightMenuInfo item null');
            continue;
          }
          cMenuInfo.menuText = RightClickMenuModel.getInstance().mulFileOrFolderString(rMenuItem?.name,
            rMenuItem.index, selectFiles.length, rightMenuInfo.currentFileInfo) ?? null;
          cMenuInfo.menuKeyString = `${rMenuItem.index}`;
          cMenuInfo.bundleName = cMenuInfo.menuKeyString;
          cMenuInfo.shortcutKeyTips = rMenuItem.labelInfo;
          cMenuInfo.onMenuClick = () => {
            this.menuClickHandler(rMenuItem, rightMenuInfo, currentFile as string, selectFiles, page);
          };
          menuInfoList.push(cMenuInfo);
        }
        if (rightMenuGroup.length > 0 && groupIndex !== rightMenuGroup.length - 1) {
          let cMenuInfo: MenuInfo = new MenuInfo();
          cMenuInfo.menuKeyString = '-' + groupIndex;
          menuInfoList.push(cMenuInfo);
        }
      }
    }*/
    this.assembleSubMenu(menuInfoList);
    return menuInfoList;
  }

  private assembleSubMenu(menuInfoList: MenuInfo[]): void {
    const firstMenuKeyIndexes = Array.from<string>(MenuConstants.MENU_LEVEL_INDEX_CONFIG.keys());
    firstMenuKeyIndexes.forEach(keyIndex => {
      if (keyIndex === MenuConstants.COMPRESS_FILE_INDEX) {
        this.updateCompressItem(menuInfoList);
        return;
      }
      this.assembleSubMenuByKeyIndex(menuInfoList, keyIndex);
    })

  }

  private updateCompressItem(menuInfoList: MenuInfo[]): void {
    const index: number | undefined =
      menuInfoList.findIndex(menuItem => menuItem.menuKeyString === MenuConstants.COMPRESS_FILE_INDEX);
    if (index !== -1) {
      const menuItemToMove: MenuInfo = menuInfoList[index];
      menuInfoList.splice(index, 1);
      let newItem: MenuInfo = new MenuInfo();
      newItem.menuText = $r('app.string.compress');
      newItem.menuKeyString = MenuConstants.COMPRESS_FILE_INDEX;
      newItem.subMenuList = [menuItemToMove];
      menuInfoList.splice(index, 0, newItem);
    }
  }


  private menuClickHandler(rMenuItem: ESObject, rightMenuInfo: ESObject,
    currentFile: string, selectFiles: string[], page: number): void {
    /*log.showInfo(`menuClickHandler item ${rMenuItem.index}`);
    if (rightMenuInfo.startMode === UnityStartMode.DESKTOP_FILE_START) {
      rightMenuInfo.windowX = this.rightClickPosition?.x ?? 0;
      rightMenuInfo.windowY = this.rightClickPosition?.y ?? 0;
    }
    // 桌面菜单点击前置处理
    const menuClickModel = this.beforeMenuClick(rMenuItem, rightMenuInfo, currentFile, selectFiles, page);
    if (menuClickModel.isClickIntercepted) {
      log.showWarn('menuClickHandler click is Intercepted');
      return;
    }
    // 透传click事件给文管
    PcFileAccess.menuClick(rMenuItem.index as number, rightMenuInfo);
    // 桌面菜单点击后置处理
    this.afterMenuClick(rMenuItem.index as number, selectFiles, currentFile, menuClickModel.responseClickPageIndex);*/
  }

  private beforeMenuClick(rMenuItem: ESObject, rightMenuInfo: ESObject,
    currentFile: string, selectFiles: string[], page: number): MenuClickModel {
    log.showInfo(`afterMenuClick index is: ${rMenuItem.index}, uri length: ${selectFiles?.length}`);
    let menuClickModel = new MenuClickModel();
    /*switch (rMenuItem.index) {
      case RcmItem.CREAT_SHORTCUT:
      case RcmItem.SEND_DESKTOP_SHORTCUT:
        const filePosition = this.getSmallElementAvailablePosition(page);
        if (!filePosition) {
          Prompt.showToast({
            message: ResourceManager.getInstance().getStringByName('add_icon_to_desktop_max'),
            bottom: PageDesktopViewModel.getInstance(this.singleContext).getToastBottom()
          });
          menuClickModel.isClickIntercepted = true;
          return menuClickModel;
        }
        menuClickModel.responseClickPageIndex = filePosition.page ?? 0;
        break;
      default:
        break;
    }*/
    return menuClickModel;
  }

  /**
   * 从屏幕查找1X1元素的位置
   * @param page 桌面页索引值
   * @returns
   */
  private getSmallElementAvailablePosition(page: number): DragGridPosition | null {
    let fileFolderPosition: DragGridPosition | null = this.getFileFolderPosition(undefined, undefined, page);
    if (fileFolderPosition) {
      return fileFolderPosition;
    }
    return fileFolderPosition;
  }

  private assembleSubMenuByKeyIndex(menuInfoList: MenuInfo[], keyIndex: string): void {
    const index: number = menuInfoList.findIndex(menuItem => {
      return menuItem.menuKeyString === keyIndex;
    });
    if (index !== -1) {
      const menuItem: MenuInfo = menuInfoList[index];
      menuInfoList.splice(index, 1);
      const childKeyIndexes = MenuConstants.MENU_LEVEL_INDEX_CONFIG.get(keyIndex);
      if (!CheckEmptyUtils.isEmptyArr(childKeyIndexes)) {
        childKeyIndexes?.forEach(keyIndex => {
          const menuInfo = this.popMenu(keyIndex, menuInfoList);
          if (menuInfo) {
            menuItem.subMenuList.push(menuInfo);
          }
        });
      }
      menuInfoList.splice(index, 0, menuItem);
    }
  }

  private popMenu(menuKeyString: string, menuInfoList: MenuInfo[]): MenuInfo | undefined {
    if (CheckEmptyUtils.isEmptyArr(menuInfoList)) {
      log.showWarn('popMenu menuInfoList empty');
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(menuKeyString)) {
      log.showWarn('popMenu menuKeyString is invalid');
      return undefined;
    }
    const index: number = menuInfoList.findIndex(menuItem => menuItem.menuKeyString === menuKeyString);
    if (index === -1) {
      log.showWarn('popMenu menuKeyString not found');
      return undefined;
    }
    const menuItem: MenuInfo = menuInfoList[index];
    menuInfoList.splice(index, 1);
    return menuItem;
  }

  /**
   * 查询文件右键菜单子菜单项列表
   * @returns
   */
  public getAllSubMenu(fileUri: string | undefined): Map<string, MenuInfo[]> {
    let res: Map<string, MenuInfo[]> = new Map();
    if (!fileUri) {
      log.showError('getAllSubMenu fileUri ino invalid');
      return res;
    }
    res.set(MenuConstants.FILE_MENU_MORE_INDEX, this.getMoreSubMenu());
    res.set(MenuConstants.SMART_FOLDER_MENU_INDEX, this.getSmartFolderSubMenu());
    res.set(MenuConstants.OPEN_MORE_MENU_INDEX, this.getOpenModeSubMenu(fileUri));
    return res;
  }

  public getSecondaryMenuInfo(menuKey: string, fileUri: string): MenuInfo[] {
    let menuInfos: MenuInfo[] = [];
    if (!menuKey || menuKey === '') {
      log.showError('getSecondaryMenuInfo invalid menuKey');
      return menuInfos;
    }
    switch (menuKey) {
      case MenuConstants.FILE_MENU_MORE_INDEX:
        menuInfos = this.getMoreSubMenu();
        break;
      case MenuConstants.SMART_FOLDER_MENU_INDEX:
        menuInfos = this.getSmartFolderSubMenu();
        break;
      case MenuConstants.OPEN_MORE_MENU_INDEX:
        menuInfos = this.getOpenModeSubMenu(fileUri);
        break;
      default:
        log.showWarn(`unknown menuKey, ${menuKey}`);
        break;
    }
    return menuInfos;
  }
  /**
   * 查询文件右键菜单“更多”子菜单项列表
   * @returns
   */
  public getMoreSubMenu(): MenuInfo[] {
    // log.showInfo(`moreSubMenu result length: ${this.rightMenuExpandManager.getNonBlankMenuList()?.length}`);
    let subMenuList: MenuInfo[] = [];
    /*let temp: ESObject[] = this.rightMenuExpandManager.getNonBlankMenuList();
    temp?.forEach((item) => {
      let createSubFolder = new MenuInfo();
      createSubFolder.menuText = item?.menuName;
      createSubFolder.bundleName = item?.bundleName;
      createSubFolder.menuKeyString = item?.menuName;
      createSubFolder.menuImgSrc = this.getApplicationIcon(item.bundleName);
      createSubFolder.onMenuClick = () => {
        log.showInfo(`onClickMoreSubMenuItem menuName: ${item?.menuName}`);
        // RightMenuViewUtils.onClickMoreSubMenuItem(item.bundleName, item.menuAbility, item.menuHandler);
      }
      subMenuList.push(createSubFolder);
    })*/
    return subMenuList;
  }

  /**
   * 查询文件右键菜单“打开方式”子菜单项列表
   * @returns
   */
  private getOpenModeSubMenu(fileUri: string): MenuInfo[] {
    // log.showInfo(`openModeSubMenu result length: ${RightMenuViewUtils.getOpenModeSubMenu(fileUri)?.length}`);
    let openModeSubMenu: MenuInfo[] = [];
    /*let temp: ESObject[] = RightMenuViewUtils.getOpenModeSubMenu(fileUri);
    temp?.forEach((item) => {
      let createOpenModeSubFolder = new MenuInfo();
      createOpenModeSubFolder.bundleName = item?.bundleName;
      createOpenModeSubFolder.moduleName = item?.moduleName;
      createOpenModeSubFolder.menuAbility = item?.menuAbility;
      createOpenModeSubFolder.menuText = item?.menuName;
      createOpenModeSubFolder.menuImgSrc = this.getApplicationIcon(item.bundleName);
      createOpenModeSubFolder.onMenuClick = () => {
        log.showInfo(`onClickMoreSubMenuItem menuName: ${item?.menuName}`);
        const context = getContext() as common.UIAbilityContext;
        RightMenuViewUtils.openModeSubMenuClick(context, fileUri, item);
      }
      openModeSubMenu.push(createOpenModeSubFolder);
    })

    let separatorItem: MenuInfo = new MenuInfo();
    separatorItem.menuKeyString = '-';
    openModeSubMenu.push(separatorItem);
    openModeSubMenu.push(this.getOpenOtherAppMenu(fileUri));*/
    return openModeSubMenu;
  }

  /**
   * 查询文件右键菜单“打开方式--选择其他应用”子菜单项列表
   * @returns
   */
  private getOpenOtherAppMenu(fileUri: string): MenuInfo {
    // 选择其他应用打开
    let openOtherApp = new MenuInfo();
    openOtherApp.menuText = $r('app.string.select_other_app')
    openOtherApp.onMenuClick = () => {
      const context = getContext() as common.UIAbilityContext;
      // RightMenuViewUtils.openOtherAppClick(context, fileUri);
    }
    return openOtherApp;
  }

  /**
   * 通过包名获取对应应用图标
   * @param bundleName
   * @returns
   */
  private getApplicationIcon(bundleName: string): string {
    log.showInfo('getApplicationIcon start');
    const bundleFlag = bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_ALL;
    try {
      const resourceInfo = bundleResourceManager.getBundleResourceInfo(bundleName, bundleFlag);
      return resourceInfo.icon;
    } catch (err) {
      const message = (err as BusinessError)?.message;
      log.showInfo(`getApplicationIcon err: ${message}`);
      return '';
    }
  }

  public getSmartFolderSubMenu(): MenuInfo[] {
    let subMenuList: MenuInfo[] = [];
    /*let temp: ESObject[] = this.rightMenuExpandManager.getSmartFolderSubMenuList();
    log.showInfo(`getSmartFolderSubMenu result length: ${temp?.length}`);
    temp?.forEach((item) => {
      let createSubFolder = new MenuInfo();
      createSubFolder.menuText = item?.menuName;
      createSubFolder.bundleName = item?.bundleName;
      createSubFolder.menuKeyString = item?.menuName;
      createSubFolder.menuImgSrc = $r('app.media.ic_folder_ai');
      createSubFolder.onMenuClick = () => {
        log.showInfo(`onClickSmartFolderSubMenuItem menuName: ${item?.menuName}`);
        // RightMenuViewUtils.onClickSmartFolderSubMenu(item?.menuHandler);
      }
      subMenuList.push(createSubFolder);
    })*/
    return subMenuList;
  }

  /**
   * 右键菜单点击事件处理
   * @param index 菜单index
   * @param uris 右键菜单范围内所有文件uri列表
   */
  public afterMenuClick(index: number, uris: string[], currentFile: string, page: number): void {
    log.showInfo(`afterMenuClick index is: ${index}, uri length: ${uris?.length}`);
    let pageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
    let isActionCut = false;
    /*switch (index) {
      case RcmItem.OPEN:
        CloseAppManager.getInstance().setStartAppType(StartType.FILE_FOLDER);
        break;
      case RcmItem.OPEN:
        pageDesktopViewModel.initSelectStatus();
        pageDesktopViewModel.selectItemClear();
            break;
      case RcmItem.RENAME:
      case RcmItem.RENAME_MULTIPLE:
        if (uris && uris.length > 0) {
          AppStorage.setOrCreate('renameFile', currentFile ? currentFile : uris[0]);
        }
        break;
      case RcmItem.SHARE:
        this.setDialogDefaultPosition(uris);
        break;
      case RcmItem.CUT:
      case RcmItem.CUT_MULTIPLE:
        isActionCut = true;
      case RcmItem.COPY:
      case RcmItem.COPY_MULTIPLE:
        if (CheckEmptyUtils.isEmptyArr(uris)) {
          log.showWarn('afterMenuClick copy fail, uris is null');
          break;
        }
        PageDesktopViewModel.getInstance(this.singleContext).menuCopyAction(uris, isActionCut);
        break;
      case RcmItem.CREAT_SHORTCUT:
      case RcmItem.SEND_DESKTOP_SHORTCUT:
        break;
      default:
        break;
    }*/
  }



  public getGuiNameByFileInfo(uri?: string): string {
    if (!uri || uri === '') {
      return ' ';
    }
    /*const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(uri);
    if (!fileInfo) {
      return ' ';
    }
    return FileOperation.getGuiNameByFileInfo(fileInfo, this.isExtensionSuffix);*/
    return '';
  }

  private getFileExtensionByName(fileName: string): string {
    if (!fileName || fileName === '') {
      return '';
    }
    let fileExtension: string = this.getFileExtension(fileName);
    /*if (fileExtension === 'dlp') {
      let dlpLocation: number = fileName.length - ThumbnailUtil.DLPLOCATION;
      let removeDlpExtension: string = fileName.slice(0, dlpLocation);
      fileExtension = this.getFileExtension(removeDlpExtension);
    }*/
    return fileExtension;
  }

  /**
   * 获取文件后缀
   * @param fileName 文件名
   * @param isFolder 是否是文件夹
   * @returns 返回文件后缀
   */
  public getFileExtension(fileName: string | undefined, isFolder: boolean = false): string {
    if (!fileName) {
      return '';
    }
    let index = fileName.lastIndexOf('.');
    let result: string = index === -1 ? '' : fileName.substring(index + 1).toLowerCase();
    log.showInfo(`getFileExtension result ${result}, isFolder: ${isFolder}`);
    return isFolder ? '' : result;
  }

  /**
   * 判断是文件还是文件夹
   * @param fileInfo fileInfo
   * @returns 文件类型
   */
  private getFileType(fileInfo: ESObject): FileType {
    if (fileInfo.isFolder) {
      return FileType.TYPE_FOLDER;
    }
    return FileType.TYPE_FILE;
  }

  private getIconByFileSuffix(fileInfo: ESObject): PixelMap | undefined {
    let fileExtension: string = this.getFileExtensionByName(fileInfo.fileName);
    log.showInfo(`getIconByFileSuffix:${fileExtension}, ${fileInfo.ino}`);
    // return ThumbnailUtil.getThumbnailPixMapByUtdTypeId(fileExtension, this.context);
    return undefined;
  }

  private getFileFolderIconID(fileInfo: ESObject): number {
    /*let resource = ThumbnailUtil.thumbnailMap.get(fileInfo.thumbnailType);
    if (resource) {
      return resource.id;
    }
    if (this.getIconByFileSuffix(fileInfo)) {
      log.showInfo('getIconByFileSuffix, is pixmap');
      return 0;
    }
    resource = $r('app.media.ic_normal_unknown');
    return resource.id;*/
    return 0;
  }

  private getShortcutIconID(fileInfo: ESObject): number {
    /*const shortcutInfo = FileOperation.getTargetInfoByShortcutUri(fileInfo.uri);
    if (!shortcutInfo) {
      return $r('app.media.ic_normal_unknown').id;
    }
    log.showInfo(`getShortcutIconID, thumbnailType:${shortcutInfo.thumbnailType}, ino:${fileInfo.ino}, mapIno:${shortcutInfo.ino}`);
    if (shortcutInfo.thumbnailType === 'image' || shortcutInfo.thumbnailType === 'video'
      || shortcutInfo.thumbnailType === 'pdf') {
      return 0;
    }
    return this.getFileFolderIconID(shortcutInfo);*/
    return 0;
  }

  /**
   * 获取文件图标id
   * @param fileInfo
   * @returns
   */
  private getThumbnail(fileInfo: ESObject): number {
    log.showInfo(`getThumbnail, thumbnailType:${fileInfo.thumbnailType}, ino:${fileInfo.ino}`);
    if (fileInfo.thumbnailType === FileSuffix.H_LINK) {
      return this.getShortcutIconID(fileInfo);
    }
    // 需要支持cachedImage的类型, 文管SDK更新后，使用map获取supportFile, 图片 视频使用缩略图显示，无图标Icon
    if (fileInfo.thumbnailType === 'image' || fileInfo.thumbnailType === 'video' || fileInfo.thumbnailType === 'pdf') {
      return 0;
    }
    return this.getFileFolderIconID(fileInfo);
  }

  private getDesktopFileArrays(fileArray: ESObject[]): DesktopFileInfo[] {
    let desktopFileArrays: DesktopFileInfo[] = [];
    for (let index = 0; index < fileArray.length; index++) {
      let resultFileInfo: ESObject = fileArray[index];
      let desktopFile: DesktopFileInfo = {
        uri: resultFileInfo.uri,
        fileName: resultFileInfo.fileName,
        thumbnail: this.getThumbnail(resultFileInfo),
        ino: resultFileInfo.ino,
        fileType: this.getFileType(resultFileInfo),
        mtime: resultFileInfo.mtime,
        size: resultFileInfo.size,
        ctime: resultFileInfo.ctime
      }
      desktopFileArrays.push(desktopFile);
    }
    return desktopFileArrays;
  }

  private async registerFolders(desktopUri: string): Promise<void> {
    log.showInfo('register folders start');
    PcFileAccess.listFilesOfFolder(desktopUri, (resultArray: ESObject[]) => {
      let desktopFileArrays: DesktopFileInfo[] = this.getDesktopFileArrays(resultArray);
      for (let file of desktopFileArrays) {
        if (file.fileType === FileType.TYPE_FOLDER) {
          PcFileAccess.listenFolder(file.uri, this.onDesktopIconChange.bind(this));
          this.registeredFolders.set(file.uri, file);
        }
      }
      this.isFoldersRegistered = true;
      log.showInfo(`register folders end ${this.registeredFolders.size}`);
    })
  }

  public isFileFolderExist(fileName: string, fileType: number, targetUri?: string): FileExistResult {
    let result: FileExistResult = {
      isExist: false
    };
    fileName = encodeURIComponent(fileName);
    if (!targetUri) {
      targetUri = PcFileAccess.desktopPath;
    }
    targetUri += '/' + fileName;
    result.isExist = PcFileAccess.isFileExists(targetUri);
    if (result.isExist) {
      const existFileInfo = this.getFileInfoByUri(targetUri);
      if (!existFileInfo) {
        result.isExist = false;
        return result;
      }
      if (existFileInfo.fileType !== fileType) {
        result.isExist = false;
        return result;
      }
      result.existFileIno = existFileInfo.ino;
    }
    return result;
  }

  private async refreshFoldersListener(desktopFileArrays: DesktopFileInfo[]): Promise<void> {
    log.showInfo('refreshFoldersListener start');
    let folders: DesktopFileInfo[] = desktopFileArrays.filter(item => {
      return item.fileType === FileType.TYPE_FOLDER;
    });
    let registeredKeys: IterableIterator<string> = this.registeredFolders.keys();
    for (let key of registeredKeys) {
      if (!folders.some(item => item.uri === key)) {
        this.unregisterFolderChange(key);
        this.registeredFolders.delete(key);
      }
    }
    for (let folder of folders) {
      if (this.registeredFolders.has(folder.uri)) {
        if (this.registeredFolders.get(folder.uri)?.ino === folder.ino) {
          continue;
        } else {
          this.unregisterFolderChange(folder.uri);
        }
      }
      PcFileAccess.listenFolder(folder.uri, this.onDesktopIconChange.bind(this));
      this.registeredFolders.set(folder.uri, folder);
      log.showInfo(`registerFolder ${folder.ino}`);
    }
  }

  /**
   * 外部拖拽文件进入桌面的处理
   * @param event 拖拽事件
   * @returns
   */
  public fileFolderEnterDesktop(event: DragEvent): void {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    let item:GridLayoutItemInfo = new GridLayoutItemInfo();
    if (!GridLayoutUtil.isValidLayoutItem(dragItemInfo)) {
      item.uri = CommonConstants.MOCK_URI;
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item.ino = '1';
      item.area = [1, 1];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', item);
    }
    AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
    AppStorage.setOrCreate<boolean>('isDrag', true);
  }

  private spaceDataTransfer(desktopUri: string, selectFiles: string[]): void {
    log.showInfo(`selectFiles length: ${selectFiles?.length}`);
    if (!selectFiles || selectFiles.length === 0) {
      return;
    }
    const wantInfo: Want = {
      bundleName: 'com.openharmony.SpaceDataTransfer',
      abilityName: 'EntryAbility',
      action: 'ohos.want.action.moveTo',
      parameters: {
        selectFileUris: selectFiles,
        targetPath: desktopUri,
      }
    };
    /*const context = GlobalHolder.getInstance().getCommonContext() as common.ServiceExtensionContext;
    context?.startAbility(wantInfo).then(() => {
      log.showInfo(`startAbility wantInfo bundleName: ${wantInfo.bundleName} `);
    }).catch((error: BusinessError) => {
      log.showError(`startAbility err: ${error?.message}`);
    });*/
  }

  /**
   * 从外部拖拽文件到桌面业务处理
   * @param event 拖拽事件
   * @returns
   */
  public async dropFileToDesktop(event: DragEvent, extraParams?: string, extraData?: string): Promise<void> {
    log.showInfo('dropFileToDesktop');
    const desktopUri: string = await PcFileAccess.getDesktop();
    // space data transfer
    /*let extraInfo: string = UdmfUtils.getExtra(extraParams);
    try {
      if (systemParameter.getSync(ENTERPRISE_SPACE_ENABLE, 'false') === 'true' && extraInfo.length > 0) {
        const extraInfoMap = this.jsonParse<Map<string, object>>(extraInfo);
        if (extraInfoMap !== undefined && extraInfoMap['action'] === 'SPACE_DATA_TRANSFER') {
          this.spaceDataTransfer(desktopUri, extraInfoMap['selectFileUris']);
          return;
        }
      }
    } catch (err) {
      log.showError(`dropFileToDesktop error, code: ${err?.code}, message: ${err?.message}`);
    }*/

    this.dropFile(event, desktopUri, extraParams, extraData);
  }

  /**
   * 从外部拖拽文件到桌面业务处理
   * @param event 拖拽事件
   * @returns
   */
  public async dropFileToRegionFolder(event: DragEvent, destUri: string, extraParams?: string,
    extraData?: string): Promise<void> {
    log.showInfo('dropFileToRegionFolder');
    // space data transfer
    /*let extraInfo: string = UdmfUtils.getExtra(extraParams);
    try {
      if (systemParameter.getSync(ENTERPRISE_SPACE_ENABLE, 'false') === 'true' && extraInfo.length > 0) {
        const extraInfoMap = this.jsonParse<Map<string, object>>(extraInfo);
        if (extraInfoMap !== undefined && extraInfoMap['action'] === 'SPACE_DATA_TRANSFER') {
          this.spaceDataTransfer(destUri, extraInfoMap['selectFileUris']);
          return;
        }
      }
    } catch (err) {
      log.showError(`dropFileToRegionFolder error, code: ${err?.code}, message: ${err?.message}`);
    }
*/
    this.dropFile(event, destUri, extraParams, extraData);
  }

  private jsonParse<T>(input: string): T | undefined {
    try {
      return JSON.parse(input) as T;
    } catch (err) {
      log.showError(`jsonParse error, code: ${err?.code}, message: ${err?.message}`);
      return undefined;
    }
  }

  /**
   * 获取拖拽文件的ino
   * @param event 拖拽事件
   * @returns
   */
  public async getFileInos(event: DragEvent): Promise<Array<string>> {
    /*try {
      const toOperateFileUris: string[] = (await UdmfUtils.getToOperateFileUris(event as DragEvent)).fileUriList;
      const inos: string[] = toOperateFileUris.map((uri: string) => {
        const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(uri);
        return fileInfo.ino;
        return '';
      });
      return inos;
    } catch (error) {
      log.showError(`getFileInos error, code: ${error?.code}, message: ${error?.message}`);
      return []; // 返回一个空数组或其他默认值
    }*/
    return []; // 返回一个空数组或其他默认值
  }

  private async getFileInfosByUri(sourceUris: string[]): Promise<ESObject[]> {
    const fileInfos: ESObject[] = [];
    /*for (let uri of sourceUris) {
      let fileInfo: ESObject | undefined = undefined;
      if (FileUtil.isShortcutByUri(uri)) {
        fileInfo = await FileOperation.getTargetInfoByShortcutUriAsync(uri);
      } else {
        fileInfo = FileInfo.fromFileUriDesktop(uri);
      }
      if (!fileInfo) {
        continue;
      }
      fileInfos.push(fileInfo);
    }*/
    log.showInfo(`getFileInfosByUri, sourceUris length:${sourceUris.length}, file length:${fileInfos.length}`);
    return fileInfos;
  }

  private async preStoreDesktopUri(sourceUris: string[], column: number, row: number, page: number,
    isShortCut: boolean): Promise<void> {
    log.showInfo(`preStoreDesktopUri [${column}, ${row}, ${page}] ${isShortCut}`);
    if (!sourceUris || sourceUris.length === 0) {
      return;
    }
    const fileInfos:ESObject = await this.getFileInfosByUri(sourceUris);
    const desktopUri: string = await PcFileAccess.getDesktop();
    let uris: string[] = this.getDesktopTargetUris(isShortCut, fileInfos, desktopUri);
    this.setDesktopPositionByUris(uris, column, row, page);
  }

  private async setFileUrisForDragPaste(event: DragEvent, column: number, row: number, page: number, isShortCut: boolean): Promise<void> {
    try {
      /*const toOperateFileUris: string[] = (await UdmfUtils.getToOperateFileUris(event as DragEvent)).fileUriList;
      await this.preStoreDesktopUri(toOperateFileUris, column, row, page, isShortCut);*/
    } catch (error) {
      log.showError(`getFileNames error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public getDragEventData(dragInfos: GridLayoutItemInfo[]): UDC.UnifiedData {
    let unifiedData: UDC.UnifiedData | null = null;
    try {
      dragInfos.forEach((item: GridLayoutItemInfo) => {
        const unifiedRecord: UDC.UnifiedRecord = setUdmfData(item);
        if (!unifiedData) {
          unifiedData = new UDC.UnifiedData(unifiedRecord);
        } else {
          unifiedData.addRecord(unifiedRecord);
        }
      })
    } catch (error) {
      log.showError(`getDragEventData error, code: ${error?.code}, message: ${error?.message}`);
      return new UDC.UnifiedData();
    }
    return unifiedData !== null ? unifiedData : new UDC.UnifiedData();
  }

  public isDragFromSideBar(extraInfo?: string): boolean {
    if (!extraInfo) {
      log.showWarn('isDragFromSideBar extraInfo is invalid');
      return false;
    }
    /*const isShortCut = extraInfo.includes(UdmfUtils.ALLOW_CREATE_SHORTCUT);
    log.showInfo(`isDragFromSideBar ${isShortCut}`);
    return isShortCut;*/
    return false;
  }

  private isDragToCreateShortCut(isCtrlKeyDown: boolean, isShiftKeyDown: boolean, isAltKeyDown: boolean,
    extraInfo: string): boolean {
    return (isCtrlKeyDown && isShiftKeyDown) || isAltKeyDown || this.isDragFromSideBar(extraInfo);
  }

  /**
   * 拖拽文件到指定文件夹
   * @param event 拖拽事件
   * @param targetUri 指定文件夹uri
   * @returns
   */
  async dropFile(event: DragEvent, targetUri: string, extraParams?: string, extraData?: string,
    isContainApp?: boolean): Promise<void> {
    /*log.showInfo(`dropfile,isContainApp:${isContainApp}`)

    const udmfInfoList: UdmfInfoList = await UdmfUtils.getToOperateFileUris(event as DragEvent);
    const toOperateFileUris: string[] = udmfInfoList.fileUriList;
    if (isContainApp) {
      Prompt.showToast({
        message: $r('app.string.app_cant_add_to_folder'),
        bottom: PageDesktopViewModel.getInstance(this.singleContext).getToastBottom()
      });
    }
    const systemDefinedPixelMapList: UDC.SystemDefinedPixelMap[] = udmfInfoList.systemDefinedPixelMapList;
    // const file: FileInfo = await FileInfo.fromFileUriAsync(targetUri);
    let extraInfo: string = UdmfUtils.getExtra(extraParams);

    let isCtrlKeyDown: boolean = false;
    let isAltKeyDown: boolean = false;
    let isShiftKeyDown: boolean = false;
    if (event && event.getModifierKeyState) {
      isCtrlKeyDown = event.getModifierKeyState(['ctrl']);
      isAltKeyDown = event.getModifierKeyState(['alt']);
      isShiftKeyDown = event.getModifierKeyState(['shift']);
    }
    let column: number = 0;
    let row: number = 0;
    let page: number = 0;
    let isFileCover: boolean = false;
    let isShortCut: boolean = this.isDragToCreateShortCut(isCtrlKeyDown, isShiftKeyDown, isAltKeyDown, extraInfo);
    if (extraData) {
      try {
        const exData: ExtraData = JSON.parse(extraData);
        isFileCover = exData.isFileCover;
        column = exData.column;
        row = exData.row;
        page = exData.page;
        if (isShortCut && !isFileCover) {
          await this.setFileUrisForDragPaste(event, column, row, page, true);
        } else if (isCtrlKeyDown && !isFileCover) {
          await this.setFileUrisForDragPaste(event, column, row, page, false);
        } else {

        }
      } catch (err) {
        log.showError(`JSON.parse extraData error, code: ${err?.code}, message: ${err?.message}`);
      }
    } else {
      log.showInfo('extraData is empty');
    }
    if (isCtrlKeyDown) {
      extraInfo += `, "isCtrlDown": true`;
    }
    if (isAltKeyDown) {
      extraInfo += `, "isAltDown": true`;
    }
    if (isShiftKeyDown) {
      extraInfo += `, "isShiftDown": true`;
    }
    log.showInfo(`drop file, isCtrlKeyDown:${isCtrlKeyDown}, isShiftKeyDown:${isShiftKeyDown}, isAltKeyDown:${isAltKeyDown}`);
    // 执行拖拽事件
    if (ArrayUtil.isEmpty(toOperateFileUris)) {
      log.showWarn('toOperateFileUris is empty');
    } else {
      // 执行文件落入
      UdmfUtils.handleDropEvent(toOperateFileUris, file, extraInfo);
    }
    if (ArrayUtil.isEmpty(systemDefinedPixelMapList)) {
      log.showWarn('systemDefinedPixelMapList is empty');
    } else {
      // 执行pixelMap落入
      CreateImageFromPixelMapTaskUtil.startCreateImageFromPixelMapTask(systemDefinedPixelMapList, file.uri);
    }*/
  }

  public unregisterFolderChange(uri: string): void {
    log.showInfo('unregisterFolder');
    PcFileAccess.stopListenFolder(uri);
  }

  private onDesktopIconChange(result: HashSet<ESObject>): void {
    log.showInfo('onDesktopIconChange');
    PcFileAccess.listFilesOfFolder(PcFileAccess.desktopPath, (resultArray: ESObject[]) => {
      let desktopFileArrays: DesktopFileInfo[] = this.getDesktopFileArrays(resultArray);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH, desktopFileArrays);
    });
    this.handleRegionFolderFileChange(result);
  }

  private handleRegionFolderFileChange(results: HashSet<ESObject>): void {
    let regionFolderFileChangeType: Map<string, boolean> = new Map();
    let deleteFileFolderMap: Map<string, HashSet<string>> = new Map();
    log.showInfo(`results length :${results.length}`);
    Array.from(results).forEach((result:ESObject) => {
      const regionFolderUri:ESObject = result.currentListenUri;
      if (!regionFolderUri) {
        log.showInfo(`currentListenUri is undefined`);
        return;
      }
      if (!this.fileChangeCallbackMap.has(regionFolderUri)) {
        log.showInfo(`listener of uri not exist:${result.currentListenUri}`);
        return;
      }
      const isDelete: boolean =
        (result.event === FileObservedChangeEvent.IN_DELETE) && (regionFolderFileChangeType.get(regionFolderUri) ?? true);
      regionFolderFileChangeType.set(regionFolderUri, isDelete);
      log.showInfo(`regionFolderUri:${regionFolderUri}, isDelete:${isDelete}`);
      if (isDelete) {
        if (!deleteFileFolderMap.has(regionFolderUri)) {
          deleteFileFolderMap.set(regionFolderUri, new HashSet());
        }
        deleteFileFolderMap.get(regionFolderUri)?.add(result.uri ?? '');
      } else {
        deleteFileFolderMap.delete(regionFolderUri);
      }
    })
    regionFolderFileChangeType.forEach((isDelete, uri) => {
      const callback = this.fileChangeCallbackMap.get(uri);
      callback?.(isDelete, deleteFileFolderMap.get(uri));
    })
    log.showInfo(`regionFolderFileChangeType :${JSON.stringify(regionFolderFileChangeType)}`);
  }

  public registerRegionFolderFileChange(uri: string, callback: Function): void {
    this.fileChangeCallbackMap.set(uri, callback);
  }

  public unregisterRegionFolderFileChange(uri: string, callback: Function): void {
    if (callback !== this.fileChangeCallbackMap.get(uri)) {
      log.showWarn(`unregister callback object is not in map, dont't delete.`);
      return;
    }
    this.fileChangeCallbackMap.delete(uri);
  }

  /**
   * subscribe file change event
   * @returns
   */
  private async subscribeFileItemStateChanged(): Promise<void> {
    log.showInfo('subscribeFileItemStateChanged');
    EvtBus.on(FileChangeEvent, this.handleFileChangeEvent.bind(this));
  }

  private onDesktopFileChange(result: ESObject[]): void {
    if (!result) {
      log.showError('onDesktopFileChange input param null!');
      return;
    }
    let distinctEvents: HashSet<string> = new HashSet<string>();
    let noRepeatArr: ESObject[] = [];
    log.showInfo(`onDesktopFileChange raw event length: ${result?.length}`+
      `inos: ${result.map((fileResultModel:ESObject):string => fileResultModel.ino ?? '').join(',')}`);
    result.forEach((fileChangeItem:ESObject)=>{
      const item: string = `${fileChangeItem.event}_${fileChangeItem.ino}`;
      const res: boolean = distinctEvents.has(item);
      // 批次事件去重
      if (!res) {
        noRepeatArr.push(fileChangeItem);
      }
      distinctEvents.add(item);
    })
    log.showInfo('onDesktopFileChange noRepeatArr length:' + noRepeatArr.length);
    // 单独处理删除事件，提前刷新桌面图标
    const deleteEventUriList:string[] =
      noRepeatArr.filter((item:ESObject):boolean => item.event === FileObservedChangeEvent.IN_DELETE).map((item:ESObject):string => item.uri);
    if (deleteEventUriList.length > 0) {
      log.showInfo('onDesktopFileChange noRepeatArr include IN_DELETE event!');
      this.curFileInfoList = this.curFileInfoList.filter((item:ESObject) =>!deleteEventUriList.includes(item.uri));
      this.handleFileInfoList(this.curFileInfoList);
      noRepeatArr = noRepeatArr.filter((item:ESObject) =>!deleteEventUriList.includes(item.uri));
    }
    // FileOperation.getFileInoByUri(noRepeatArr, PcFileAccess.desktopPath);
    // for (const eventItem of noRepeatArr) {
    noRepeatArr.forEach((eventItem:ESObject)=>{
      // 处理写入完成事件
      if (eventItem.event === FileObservedChangeEvent.IN_CLOSE_WRITE) {
        if (this.refreshUriListeners.has(eventItem.ino)) {
          const listener: RefreshUriListener = this.refreshUriListeners.get(eventItem.ino) as RefreshUriListener;
          listener?.onRefreshUri(eventItem.uri);
        }
      }
    })
    this.refreshDesktopFiles();
  }

  private notifyDesktopFileDrop(uris: string[] | undefined, isShow: boolean): void {
    log.showInfo('notifyDesktopFileDrop: ' + uris?.length);
    if (!uris || uris.length === 0) {
      return;
    }
    let map: Map<string, string> = PageDesktopViewModel.getInstance(this.singleContext).getFileInfoMap();
    if (!map) {
      return;
    }
    uris.forEach((uri: string) => {
      const ino: string | undefined = map.get(uri);
      log.showDebug(`handleFileChangeEvent ino: ${ino}`);
      if (ino) {
        this.context?.eventHub.emit(`filesToFolder${ino}`, isShow);
      }
    })
  }

  private notifyCompletedTimeOut(uris: string[] | undefined): void {
    if (this.notifyTimeoutId === CommonConstants.INVALID_VALUE) {
      this.notifyTimeoutId = setTimeout(() => {
        // 剪切完成后，显示剩余未剪切文件
        this.notifyDesktopFileDrop(uris, true);
        this.notifyTimeoutId = CommonConstants.INVALID_VALUE;
      }, NOTIFY_DELAY);
    }
  }

  private handleRecycleBin(event: FileChangeEvent) {
    const windowId: number | undefined = event?.parameters?.windowId;
    const windowAction: FileManagerWindowAction | undefined = event?.parameters?.windowAction;
    if (!windowId || windowAction === undefined) {
      return
    };
    switch (windowAction) {
      case FileManagerWindowAction.ENTER_RECYCLE_BIN:
        // 确保回收站窗口Id不重复, 文管窗口进入回收站, 记录windowId
        if (!this.recycleBinWindowIdList.includes(windowId)) {
          this.recycleBinWindowIdList.push(windowId);
          log.showInfo(`handleRecycleBin ${windowId} enter recycle bin,
            recycleBinWindowIdList: ${this.recycleBinWindowIdList}`);
        }
        break;
      case FileManagerWindowAction.LEAVE_RECYCLE_BIN:
        // 回收站窗口离开回收站, 删除窗口Id
        const index = this.recycleBinWindowIdList.indexOf(windowId);
        if (index >= 0) {
          this.recycleBinWindowIdList.splice(index, 1);
          log.showInfo(`handleRecycleBin ${windowId} leave recycle bin,
            recycleBinWindowIdList: ${this.recycleBinWindowIdList}`);
        }
        break;
      default:
        log.showWarn(`wrong action: ${windowAction}`);
    }
  }

  private async handleFileChangeEvent(event: FileChangeEvent): Promise<void> {
    log.showInfo('handleFileChangeEvent type: ' + event.event);
    if (!event || !event.parameters) {
      return;
    }
    if (event.parameters.bundleName !== FILEMANAGER_BUNDLE_NAME) {
      log.showWarn('handleFileChangeEvent source not filemanager');
      return;
    }
    this.handleRecycleBin(event);
    const action: string | undefined = event.parameters?.action;
    const status: number | undefined = event.parameters?.status;
    log.showInfo(`handleFileChangeEvent action: ${action}, status: ${status}`);
    const actionFiles: string[] | undefined = event.parameters?.actionFiles;
    const failedFiles: string[] | undefined = event.parameters?.failFiles;
    if (action === FileEventAction.CUT) {
      if (status === FileEventStatus.COMPLETED) {
        this.notifyCompletedTimeOut(failedFiles);
        return;
      }
      const isShow: boolean = (status === FileEventStatus.CANCEL || status === FileEventStatus.ABORT);
      this.notifyDesktopFileDrop(isShow ? failedFiles : actionFiles, isShow);
      return;
    }
    let pasteFileUri: string[] | undefined = event.parameters?.pasteFileUri;
    if (pasteFileUri !== undefined && Array.isArray(pasteFileUri) && pasteFileUri.length) {
      let pasteFileIno: string[] = []
      /*pasteFileUri.forEach(uri => {
        pasteFileIno.push(FileInfo.fromFileUriDesktop(uri).ino);
      });*/
      PageDesktopViewModel.getInstance(this.singleContext).selectAllOrSomeDesktopItem(pasteFileIno);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED, pasteFileUri);
      log.showInfo(`handleFileChangeEvent, pasteFileUri: ${pasteFileUri.length}`);
    }

    try {
      const isExtensionSuffix: boolean | undefined = event.parameters?.isExtensionSuffix;
      if (isExtensionSuffix !== undefined && isExtensionSuffix !== AppStorage.get<boolean>('isExtensionSuffix')) {
        this.isExtensionSuffix = isExtensionSuffix;
        AppStorage.setOrCreate<boolean>('isExtensionSuffix', isExtensionSuffix);
        this.filePreferences?.putSync('isExtensionSuffix', isExtensionSuffix);
        this.filePreferences?.flush();
        log.showInfo(`handleFileChangeEvent isExtensionSuffix: ${isExtensionSuffix}`);
      }
    } catch (error) {
      log.showError(`put isExtensionSuffix error: code: ${error?.code}, message: ${error?.message}`);
    }
    this.handleCompressAndDecompressEvent(event);
  }

  private handleCompressAndDecompressEvent(event: FileChangeEvent): void {
    const compressUri: string = event.parameters?.compressEvent ?? '';
    // compressing 为true，表示压缩或者解压缩开始;为false，表示压缩或者解压缩结束
    const compressing: boolean = !!event.parameters?.status;
    if (!compressUri || compressUri === '') {
      log.showWarn('compressUri is undefined');
      return;
    }
    /*const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(compressUri);
    const action: string | undefined = event.parameters?.action;
    if (!fileInfo || !fileInfo.ino) {
      log.showError('openFileDetail Error, the file does not exist');
    }
    if (action === FileEventAction.COMPRESS) {
      this.handleCompressEvent(compressing, fileInfo, compressUri);
    } else if (action === FileEventAction.DECOMPRESS) {
      this.handleDecompressEvent(compressing, fileInfo, compressUri);
    } else {
      log.showError(`handleCompressAndDecompressEvent unknown action ${action}`);
    }*/
  }

  private handleCompressEvent(compressing: boolean, fileInfo: ESObject, compressUri: string): void {
    // 压缩开始
    if (compressing) {
      this.setFileDisable(compressUri);
      log.showInfo(`handleCompressEvent start Ino: ${fileInfo?.ino}`);
    } else {
      // 压缩结束
      this.compressFileToRename(fileInfo, compressUri);
      this.setFileEnable(fileInfo);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED, [compressUri]);
      log.showInfo(`handleCompressEvent completed Ino: ${fileInfo?.ino}`);
    }
  }

  private compressFileToRename(fileInfo: ESObject, compressUri: string): void {
    // 压缩完成
    const isFileFolderExist = this.curFileInfoList.map((fi:ESObject):string => fi.uri).includes(compressUri);
    if (isFileFolderExist) {
      this.context?.eventHub.emit('FileFolderCompressToRenameEvent', fileInfo.ino);
    } else {
      AppStorage.setOrCreate<string>('newCreateFolder', compressUri);
    }
  }

  private handleDecompressEvent(compressing: boolean, fileInfo: ESObject, compressUri: string): void {
    // 解压开始
    if (compressing) {
      this.setFileDisable(compressUri);
      log.showInfo(`handleDecompressEvent start Ino: ${fileInfo?.ino}`);
    } else {
      // 解压结束
      this.setFileEnable(fileInfo);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED, [compressUri]);
      log.showInfo(`handleFileChangeEvent completed Ino: ${fileInfo?.ino}`);
    }
  }

  private setFileDisable(uri: string) {
    AppStorage.setOrCreate<string>('compressUri', uri);
  }

  private setFileEnable(fileInfo: ESObject) {
    AppStorage.setOrCreate<string>('compressUri', '');
    fileInfoUpdateManager.refreshCompressStatus(fileInfo?.ino);
  }

  private async handleUnLockEvent(event: ScreenLockEvent): Promise<void> {
    log.showInfo(`handleUnLockEvent this.firstLoaded: ${this.firstLoaded}, lockStatus: ${event?.lockStatus}, ` +
      `event.isLockScreen: ${event?.isLockScreen}`);
    // if not event or has Load DeskTop, update firstLoaded here 0202
    if (!event) {
      log.showInfo('handleUnLockEvent event invalid');
      return;
    }
    if (event.isLockScreen || event.lockStatus === ScreenLockEvent.LOCK_STATUS_SECURE) {
      log.showInfo('handleUnLockEvent isLockScreen');
      return;
    }
    this.tryToLoadDesktopFiles('handleUnLockEvent');
    if (this.firstLoaded) {
      this.refreshDesktopFiles(false);
    }
  }

  public async tryToLoadDesktopFiles(reason: string): Promise<void> {
    log.showInfo(`tryToLoadDesktopFiles start reason: ${reason} firstLoaded：${this.firstLoaded} `);
    if (this.firstLoaded) {
      log.showWarn('tryToLoadDesktopFiles failed, has loaded');
      return;
    }
    let desktopUri: string = await PcFileAccess.getDesktop();
    // 有锁屏密码重启后，处于锁屏状态，磁盘未挂载，这里会没有数据，
    let fileExist: boolean = PcFileAccess.isFileExists(desktopUri);
    if (!fileExist) {
      // 还未挂载成功
      if (this.unlockRetryTimes === MAX_RETRY_TIMES) {
        log.showError('tryToLoadDesktopFiles max times, desktop path mounted failed');
        return;
      }
      this.unlockRetryTimes++;
      setTimeout(() => {
        this.tryToLoadDesktopFiles(reason);
      }, RETRY_DURING);
    } else {
      this.unlockRetryTimes = 0;
      this.initDesktopFileFolder();
      this.refreshDesktopFiles(true);
      this.firstLoaded = true;
      log.showInfo(`tryToLoadDesktopFiles succeed reason: ${reason}`);
    }
  }

  public isRecycleBin(bundleName?: string, persistentId?: number,
    isOpenFromPopup?: boolean, isClickFromDockFileManager?: boolean): boolean {
    if (!bundleName || persistentId === undefined) {
      log.showWarn('param is undefined');
      return false;
    }
    if (!PCDockUtils.isPcFileManager(bundleName)) {
      return false;
    }
    if (isClickFromDockFileManager || isOpenFromPopup) {
      log.showInfo(`isRecycleBin isClickFromDockFileManager: ${isClickFromDockFileManager}, isOpenFromPopup: ${isOpenFromPopup}`);
      return false;
    }
    return this.recycleBinWindowIdList.includes(persistentId);
  }

  public refreshRecycleBinIconState(): void {
    log.showInfo('start list recycleBin');
    PcFileAccess.listFilesOfFolder(PcFileFolderConstants.recycleBinPath, (resultArray: ESObject[]) => {
      if (resultArray === undefined || resultArray === null) {
        log.showError('list recycleBin fail, resultArray null');
        return;
      }
      if (resultArray.length === 0) {
        this.fileCallbackMap.forEach((callBack: Function) => {
          callBack(true);
        })
        log.showInfo('recycleBin is empty');
      } else {
        this.fileCallbackMap.forEach((callBack: Function) => {
          callBack(false);
        })
        log.showInfo(`recycleBin not empty: ${resultArray.length} files`);
      }
    }).catch((error: BusinessError) => {
      log.showError(`list recycleBin fail, code: ${error?.code}, message: ${error?.message}`);
    })
  }

  private callBack = ((callback: ESObject[]): void => {
    log.showInfo('recycleBin status change');
    if (dragToSnapshotDelayTimer === null) {
      this.refreshRecycleBinIconState();
      dragToSnapshotDelayTimer = setTimeout(() => {
        if (this.isTimeOut) {
          this.refreshRecycleBinIconState();
          this.isTimeOut = false;
        }
        dragToSnapshotDelayTimer = null;
      }, DELAY_REFRESH_RECYCLEBIN);
    } else {
      this.isTimeOut = true;
    }
  });

  public registerRecycleBinListener(screenId: number, callback: Function): void {
    log.showInfo(`start listen recycleBin, screenId ${screenId}`);
    this.fileCallbackMap.set(screenId, callback);
  }

  public unRegisterRecycleBinListener(screenId: number): void {
    log.showInfo(`end listen recycleBin, screenId ${screenId}`);
    this.fileCallbackMap.delete(screenId);
  }

  public registerRecycleBinListenerFileAccess(): void {
    try {
      PcFileAccess.listenFolder(PcFileFolderConstants.recycleBinPath, this.callBack, this.context);
    } catch (error) {
      log.showError(`listenFolder fail, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public doRevoke(): void {
    log.showInfo('doRevoke');
    PcFileAccess.doRevoke();
  }

  /**
   * 判断是否能撤销
   */
  public canUndo(): boolean {
    /*try {
      const canUndo: boolean = OperatorHistoryModel.canUndo();
      log.showInfo(`canUndo: ${canUndo}`);
      return canUndo;
    } catch (error) {
      log.showError(`canUndo fail, code: ${error?.code}, message: ${error?.message}`);
    }*/
    return false;
  }

  /**
   * 获取右键菜单-撤销内容
   */
  public getUndoText(): string {
    /*try {
      const undoText: string = OperatorHistoryModel.getUndoText();
      log.showInfo(`getUndoText : ${undoText}`);
      return undoText;
    } catch (error) {
      log.showError(`getUndoText fail, code: ${error?.code}, message: ${error?.message}`);
    }*/
    return '';
  }

  /**
   * 桌面反撤销
   */
  public doReverseRevoke(): void {
    log.showInfo('doReverseRevoke');
    PcFileAccess.doReverseRevoke();
  }

  /**
   * 判断是否能撤销
   */
  public canRedo(): boolean {
    /*try {
      const canRedo: boolean = OperatorHistoryModel.canRedo();
      log.showInfo(`canRedo: ${canRedo}`);
      return canRedo;
    } catch (error) {
      log.showError(`canRedo fail, code: ${error?.code}, message: ${error?.message}`);
    }*/
    return false;
  }

  /**
   * 获取右键菜单-反撤销内容
   */
  public getRedoText(): string {
    /*try {
      const redoText: string = OperatorHistoryModel.getRedoText();
      log.showInfo(`getRedoText : ${redoText}`);
      return redoText;
    } catch (error) {
      log.showError(`getRedoText fail, code: ${error?.code}, message: ${error?.message}`);
    }*/
    return '';
  }

  /**
   * 打开文件详情
   */
  public openFileDetail(fileUri: string[], isClickFolder: boolean = false): void {
    /*let fileInfoArray: ESObject[] = fileUri.map(item => FileInfo.fromFileUriDesktop(item))
    if (!fileInfoArray) {
      log.showError('openFileDetail Error, the file does not exist');
      return;
    }*/
    /*let point: Point = new Point(0, 0);
    // 拉起文件的详情页面需要传入坐标用于确定文管详情弹窗的位置，点击时跟手打开，快捷键时展示在文件名下方
    if (!isClickFolder) {
      const rect: RectInfo = ItemUtils.getRectById(`FileFolderComponent_FileName_${fileInfoArray[0].ino}`);
      if (rect) {
        point.x = vp2px(Number(rect.left));
        point.y = vp2px(Number(rect.bottom));
      }
    } else {
      point.x = this.rightClickPosition?.x ?? 0;
      point.y = this.rightClickPosition?.y ?? 0;
    }
    log.showInfo(`show detail window point x: ${point.x}, y: ${point.y}`);
    FileOperation.openDetail(fileInfoArray, point);*/
  }

  public openFilePreview(fileUri: string): void {
    if (!fileUri) {
      log.showError('openFilePreview fileUri invalid');
      return;
    }
    /*const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(fileUri);
    if (!fileInfo) {
      log.showError('openFilePreview Error, the file does not exist');
      return;
    }
    log.showInfo(`quickViewByService ino: ${fileInfo.ino}`);
    FileOperation.quickViewByService(fileUri, fileInfo.fileName, fileInfo.isFolder);*/
  }

  /**
   * 传入鼠标右键坐标
   */
  public setRightClickPosition(windowX: number, windowY: number): void {
    this.rightClickPosition = {
      x : windowX,
      y : windowY
    }
  }

  /**
   * 设置桌面菜单状态
   */
  public setMenuShowStatus(isMenuShow: boolean): void {
    this.isMenuShow = isMenuShow;
  }

  /**
   * 获取桌面菜单状态
   */
  public getMenuShowStatus(): boolean {
    return this.isMenuShow;
  }

  private getExtra(extraParams?: string): string {
    let extraInfo: string = '';
    if (extraParams) {
      let tempExtraInfo: string = '';
      try {
        tempExtraInfo = JSON.parse(extraParams).extraInfo;
      } catch (err) {
        log.showError('extraParams cant parse, try to match');
      }
      if (tempExtraInfo !== undefined) {
        extraInfo = tempExtraInfo;
      }
    }
    return extraInfo;
  }

  /**
   * 设置拖拽到pc桌面的文件文件夹角标（剪切或者复制）
   */
  public setFileFolderBadge(event: DragEvent, extraParams?: string): void {
    // 获取 extraInfo 字符串
    const extraInfo = this.getExtra(extraParams);
    const regex = /drag_from_device_(.{16})/;
    const match = extraInfo.match(regex);
    try {
      // 来自文管侧边栏的固定文件夹目录，设置角标为移动角标（没有绿色加号）
      if (extraInfo?.includes('fromSidebar_')) {
        event.setResult(DragResult.DROP_DISABLED);
        event.dragBehavior = DragBehavior.MOVE;
        return;
      }
      // 将 extraInfo 解析为对象
      const extraInfoMap = this.jsonParse<Map<string, object>>(extraInfo);
      // 先定义 OriginalSN，确保不抛出异常
      let originalSN: string | undefined;

      if (match && match[1]) {
        originalSN = match[1];
      } else if (extraInfoMap && extraInfoMap['drag_from_device']) {
        originalSN = extraInfoMap['drag_from_device'];
      }
      if (!originalSN) {
        this.setBadgeWhenNoSN(event, extraInfo);
        return;
      }
      //携带sn，根据sn判断是否跨端拖拽
      if (originalSN && originalSN !== this.deviseSN) {
        this.setCopyBadge(event);
        return;
      }
      this.setMoveBadge(event);
      return;
    } catch (err) {
      log.showDebug('Failed to parse extraInfo,maybe not have device SN');
    }
  }

  private setBadgeWhenNoSN(event: DragEvent, extraInfo: string): void {
    //如果是桌面内元素拖拽，是move
    if (extraInfo && extraInfo.includes('scb')) {
      this.setMoveBadge(event);
      return;
    }
    //否则是三方应用,除指定应用外，其他响应allowDrop
    if (extraInfo && (extraInfo.includes('HiSearch') || extraInfo.includes('fromUserSidebar') ||
    extraInfo.includes('fromFileView') || extraInfo.includes('phoneFile'))) {
      this.setCopyBadge(event);
    }
  }

  private setMoveBadge(event: DragEvent): void {
    event.setResult(DragResult.DROP_ENABLED);
    event.dragBehavior = DragBehavior.MOVE;
  }

  private setCopyBadge(event: DragEvent): void {
    AppStorage.setOrCreate<boolean>('copyToDesktop', true);
    event.setResult(DragResult.DROP_ENABLED);
    event.dragBehavior = DragBehavior.COPY;
  }

  /**
   * 获取桌面目标uris,桌面根据uri提前预存元素在桌面的位置，在收到文管的桌面刷新事件时获取元素的桌面位置
   * @returns
   */
  private getDesktopTargetUris(isShortCut: boolean, fileInfos: ESObject[], desktopUri: string): string[] {
    if (!fileInfos || fileInfos.length === 0) {
      return [];
    }
    /*if (isShortCut) {
      return ThreadCommonUtil.getDupShortcutFileNameForDesktop(fileInfos, desktopUri);
    }
    return ThreadCommonUtil.getDupFileNameForDesktop(fileInfos, desktopUri);*/
    return [];
  }

  /**
   * 通过文件uri以及文件大小获取文件hover详细信息
   * @param fileUri
   * @param folderSize
   * @returns
   */
  public getFileSummaryByUri(fileUri: string | undefined, folderSize: number = -1): string[] {
    if (!fileUri) {
      log.showError('getFileSummaryByUri fileUri invalid');
      return [];
    }
    /*const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(fileUri);
    if (!fileInfo) {
      log.showError('getFileSummaryByUri Error, the file does not exist');
      return [];
    }*/
    let summaryRes: string[] = [];
    /*log.showInfo('desktop file getFileSummary');
    summaryRes = FileOperation.getFileSummary(fileInfo, folderSize);
    log.showInfo(`desktop file getFileSummary res length: ${summaryRes.length}, folder size: ${folderSize}`);*/
    return summaryRes;
  }

  /**
   * 通过文件夹uri获取文件夹大小
   * @param fileUri
   * @returns
   */
  public async getFolderSizeByUri(fileUri: string): Promise<number> {
    /*const fileInfo: FileInfo = FileInfo.fromFileUriDesktop(fileUri);
    if (!fileInfo) {
      log.showError('getFolderSizeByUri Error, the file does not exist');
      return -1;
    }
    log.showInfo('desktop file getFolderSizeByUri');
    return FileOperation.getFolderSize(fileInfo);*/
    return 0;
  }

  /**
   * super fold 折叠态，右键粘贴文件需要复制到对应page
   * @param page
   * @returns
   */
  public async pasteFileToFixedPage(page: number, isShortCut: boolean): Promise<void> {
    let fileNameAndIsFolder: Map<string, boolean> = new Map<string, boolean>();
    try {
      /*const pasteData = await PasteBoardUtil.getPasteData();
      const pasteboardData = await PasteBoardUtil.getUriFromPasteboard(pasteData);*/
      /*if ((!pasteboardData) || ArrayUtil.isEmpty(pasteboardData.fileUriList)) {
        log.showError(`file uri list not in paste board`);
        return;
      }*/
      // await this.preStoreDesktopUri(pasteboardData.fileUriList, 0, 0, page, isShortCut);
    } catch (error) {
      log.showError(`get paste data error ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 创建智慧文件夹
   * @returns
   */
  public createSmartNewFolder(): void {
    log.showInfo('createSmartNewFolder in');

    let want: Want = {
      bundleName: 'com.ohos.filemanager',
      abilityName: 'MainAbility',
      parameters: {
        'fileManagerMode': 'createSmartFolder',
        'fileUri': ''
      }
    };
    try {
      this.context?.startAbility(want).then(() => {
        log.showInfo('startAbility createSmartNewFolder success');
      });
    } catch (error) {
      log.showWarn(`Error occurred in createSmartNewFolder: ${error.message}, Code: ${error.code}`);
    }
  }

  public async moveFile(srcUri: string, destUri: string): Promise<string> {
    return await PcFileAccess.moveFile(srcUri, destUri);
  }

  public async moveFileToDesktop(srcUri: string): Promise<string> {
    const destUri = await PcFileAccess.getDesktop();
    return await PcFileAccess.moveFile(srcUri, destUri);
  }

  public listFilesOfFolder(uri: string, callback: Function): void {
    PcFileAccess.listFilesOfFolder(uri, (resultArray: ESObject[]) => {
      let desktopFileArrays: DesktopFileInfo[] = this.getDesktopFileArrays(resultArray);
      callback(desktopFileArrays);
    })
  }

  public registerFolderChange(uri: string, callback: () => void): void {
    PcFileAccess.listenFolder(uri, () => {
      callback();
    })
  }

  public deleteFileOrFolderByName(fileName: string): void {
    let uri: string = this.getFolderUriByName(fileName);
    try {
      let fileUri: fileuri.FileUri = new fileuri.FileUri(uri);
      let filePath: string = fileUri.path;
      if (fs.statSync(filePath).isDirectory()) {
        fs.rmdirSync(filePath);
      } else {
        fs.unlinkSync(filePath);
      }
    } catch (err) {
      log.showError(`deleteFileOrFolderByName error, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  public getFolderUriByName(fileName: string, targetUri?: string): string {
    fileName = encodeURIComponent(fileName);
    if (!targetUri) {
      targetUri = PcFileAccess.desktopPath;
    }
    targetUri += '/' + fileName;
    return targetUri;
  }

  public notifyFoldersRefresh(folderUris: string[], includeDesktop: boolean = true): void {
    log.showInfo(`notifyFoldersRefresh, includeDesktop:${includeDesktop}`);
    let uris: string[] = [];
    folderUris?.forEach(x => {
      if (!CheckEmptyUtils.isEmpty(x)) {
        uris.push(x);
      }
    });
    if (includeDesktop) {
      uris.push(PcFileAccess.desktopPath);
    }
    PcFileAccess.notifyFolderRefresh(uris);
  }

  /**
   * 获取创建快捷方式菜单项
   * @returns
   */
  public getCreateShortcutMenu(): MenuInfo {
    let createShortCut: MenuInfo = new MenuInfo();
    createShortCut.menuText = $r('app.string.type_shortcut');
    createShortCut.menuImgSrc = $r('app.media.ic_new_shortcut');
    createShortCut.onMenuClick =
      (column?: number, row?: number, page?: number, target?: GridLayoutItemInfo): void => {
      log.showInfo(`onClick createShortcutFile, ${!!target}`);
      this.createShortCutFile(column ?? 0, row ?? 0, page ?? 0, target?.uri);
    }
    return createShortCut;
  }

  /**
   * 获取粘贴快捷方式菜单
   * @returns
   */
  public getPasteShortcutMenu(): MenuInfo {
    let pasteShortCut: MenuInfo = new MenuInfo();
    pasteShortCut.menuText = $r('app.string.paste_shortcut');
    pasteShortCut.onMenuClick =
      (column?: number, row?: number, event?: ClickEvent, page?: number, target?: GridLayoutItemInfo): void => {
        log.showInfo(`buildPasteShortcutMenu, ${column} ${row} ${page} ${!!target}`);
        if (!target) {
          log.showError('paste fail, target is null');
          return;
        }
        log.showInfo(`pasteShortCut, ${target?.infoId}, ${target.ino}`);
        this.pasteShortcut(target.uri);
      };
    return pasteShortCut;
  }

  /**
   * 获取文件快捷方式存储的源文件uri
   * @param uri 快捷方式的uri
   * @returns 快捷方式指向文件的uri
   */
  public getShortCutTargetUri(uri: string | undefined): string {
    if (!uri) {
      log.showError(`getShortCutTargetUri uri is emtpy`);
      return '';
    }
    /*const shortcutManager = new ShortcutManager();
    const shortcutFileInfo = shortcutManager.parseShortCut(FileUtil.getPathFromUri(uri));
    if (!shortcutFileInfo?.targetUri) {
      log.showError('cant get the shortcutFileInfo');
      return '';
    }
    return FileUtil.getUriFromPath(shortcutFileInfo?.targetUri);*/
    return '';
  }

  /**
   * 是否为快捷方式
   * @returns
   */
  public isShortcutFile(fileFolderInfo: GridLayoutItemInfo): boolean {
    if (fileFolderInfo.fileType === FileType.TYPE_FOLDER) {
      return false;
    }
    const suffix = this.getFileExtension(fileFolderInfo.fileFolderName ?? '', false);
    return suffix === FileSuffix.H_LINK;
  }

  /**
   * 获取快捷方式映射对象的文件类型
   * @returns
   */
  public getShortcutTargetFileType(fileFolderInfo: GridLayoutItemInfo): FileType | undefined {
    if (!fileFolderInfo.uri) {
      log.showWarn('getShortcutTargetFileType, uri is null');
      return undefined;
    }
    const shortcutInfo = this.getTargetInfoByShortcutUri(fileFolderInfo.uri);
    if (!shortcutInfo) {
      log.showWarn(`getShortcutTargetFileType, cant find shortcutInfo, ino:${fileFolderInfo.ino}`);
      return undefined;
    }
    return shortcutInfo.fileType;
  }

  /**
   * 获取快捷方式源文件的信息
   * @param uri 快捷方式的uri
   * @returns 快捷方式指向文件的文件信息
   */
  public getTargetInfoByShortcutUri(uri: string | undefined): FileFolderInfo | undefined {
    if (!uri || uri === '') {
      log.showWarn('getTargetInfoByShortcutUri, file uri is null');
      return undefined;
    }
    let fileInfo: ESObject | undefined = undefined;
    try {
      // fileInfo = FileOperation.getTargetInfoByShortcutUri(uri);
    } catch (error) {
      log.showError(`getTargetInfoByShortcutUri error, ${error?.code}, ${error?.message}`);
      return undefined;
    }
    if (!fileInfo) {
      log.showWarn('getTargetInfoByShortcutUri, file is not exist');
      return undefined;
    }
    const fileFolderInfo = new FileFolderInfo(fileInfo.uri);
    fileFolderInfo.ino = fileInfo.ino;
    fileFolderInfo.fileName = fileInfo.fileName;
    fileFolderInfo.mtime = fileInfo.mtime;
    fileFolderInfo.mtimeMs = fileInfo.mtimeMs;
    fileFolderInfo.ctime = fileInfo.ctime;
    fileFolderInfo.fileType = this.getFileType(fileInfo);
    fileFolderInfo.thumbnail = this.getThumbnail(fileInfo);
    return fileFolderInfo;
  }

  /**
   * 创建快捷方式
   */
  public async createShortCutFile(column: number, row: number, page: number, uri?: string): Promise<void> {
    const shortPosition: DesktopItemPosition = {
      column: column,
      row: row,
      page: page
    }
    const actionId = FileFolderService.generateActionId();
    FileFolderService.setDesktopPosition(actionId, shortPosition);
    const shortcutAction = new FileShortCutDesktopAction(actionId, '');
    let desktopUri = uri ?? await PcFileAccess.getDesktop();
    const want: Want = {
      bundleName: 'com.ohos.filemanager',
      abilityName: 'CreatShortcutAbility',
      parameters: {
        'destUri': desktopUri,
        'fileShortCutDesktopAction': shortcutAction.toJSONString()
      }
    };
    try {
      this.context?.startAbility(want).then(() => {
        log.showInfo('startAbility createShortcutFile success');
      });
    } catch (error) {
      log.showError(`Error occurred in createShortcutFile: ${error?.message}, Code: ${error?.code}`);
    }
  }

  public setDesktopPositionByUris(uris: string[], column: number, row: number, page: number): void {
    if (!uris || uris.length === 0) {
      return;
    }
    this.uris.clear();
    for (let i = 0; i < uris.length; i ++) {
      this.uris.set(uris[i], [column, row, page]);
    }
    log.showInfo(`setDesktopPositionByUris [${column}, ${row}, ${page},]`);
  }

  public getTipsAvailableHeight(): number {
    let availAbleHeight: number = 0;
    availAbleHeight = AppStorage.get<number>('screenHeight') ?? 0;
    return availAbleHeight;
  }

  public getTextAreaAvailableHeight(textAreaTop: number, screenId?: number): number {
    let availAbleTop: number = 0;
    const dockHeight: number = SCBSceneSessionManager.getInstance().
      getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId).currRect.height.getVp();
    const screenHeight = AppStorage.get<number>('screenHeight') ?? 0;
    const bottomOccupiedHeight = dockHeight + FileFolderStyleConstants.TEXTAREA_DISTANCE_TO_DOCK;
    availAbleTop = screenHeight - bottomOccupiedHeight;
    log.showInfo('getTextAreaAvailableHeight notFold [%{public}d, %{public}d, %{public}d, %{public}d, %{public}d]',
      textAreaTop, screenId, screenHeight, availAbleTop, dockHeight);
    return availAbleTop - textAreaTop;
  }

  public async isShowPasteShortcutMenu(): Promise<boolean> {
    // return ShortcutUtil.isShowPasteShortcut();
    return false;
  }

  /**
   * 桌面文件文件夹初始化
   */
  private initDesktopFileFolder(): void {
    log.showInfo('initDesktopFileFolder');
    this.registerFileChange();
    // this.rightMenuExpandManager.initSmartFolder();
  }

}
