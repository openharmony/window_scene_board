/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
  componentUtils,
  display,
  EditableLeftIconType,
  EditableTitleBar,
  inspector,
  Prompt,
  router,
  window,
  SymbolGlyphModifier,
  promptAction
} from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
// import { HdsNavigation, HdsNavigationAttribute } from '@kit.UIDesignKit';
import { DesktopIntelligentSettingPage } from './desktopSetting/DesktopIntelligentSettingPage';
import DesktopSetting from './desktopSetting/DesktopSettingPage';
import { OUTER_DESKTOP_EDIT, OuterDesktopEditPage } from './desktopSetting/OuterDesktopEditPage';
import { MAGIC_SCREEN, MagicScreenHome } from './MagicSreenHome';
import { SUB_SCREEN_THEME, SubScreenTheme } from './SubScreenTheme';
import { AigcParams } from '../uiability/AigcAbility';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import EditWallpaper from './EditWallpaper';
import { EventEmitter, WallPaper, WallPaperInfo } from "@ohos/themeservicekit";
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { ThemeInfoAdapter } from '../themeInfoAdapter/ThemeInfoAdapter';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { fileIo, picker } from '@kit.CoreFileKit';
import { Constants } from '../constants/wallpaperPathConstants';
import { ImageShowStyle, ShowWallpaperPage } from './ShowWallpaperPage'
import { image } from '@kit.ImageKit';
import { WallPageType, WallpaperEditPage } from './WallpaperEditPage';
import { commonEventManager, wallpaper } from '@kit.BasicServicesKit';
import { ImageUtils } from '../utils/ImageUtils';
import { LogUtil } from '@ohos/lottie';
import { CompleteImageAdapter } from '../utils/ImageFitProcessor';
import { ScreenSetting } from './ScreenSetting';
import { PCUtils } from '../utils/PCUtils';

const TAG: string = 'ThemeHome';
const INTELLIGENT_SETTING_PAGE: string = 'intelligentSettingPage';
const SETTING_EXTENSION_ABILITY_NAME: string = 'SettingThemeComponentExtAbility';
const THEME_APP_BUNDLE: string = 'com.ohos.thememanager';
const FONT_CREATION_PRIVACY_PAGE: string = 'FontCreationPrivacyPage';

@Entry
@Component
struct ThemeHome {
  private selectedImageUri: string = '';
  private wallpaperStyle: ImageShowStyle = ImageShowStyle.ImageShowStyleFitScreen
  private context = getContext(this) as common.UIAbilityContext;
  private static readonly THEME_GALLEY: string = 'themeGallery';
  private inspector: inspector.ComponentObserver = inspector.createComponentObserver('ThemeHome');
  @Provide('pageInfos') public pageInfos: NavPathStack = new NavPathStack();
  @Provide('isShowThemeDetail') isShowThemeDetail: boolean = false;
  @Provide('isPersonalizeShow') isPersonalizeShow: boolean = false;
  @Provide('isThemeDetailLoading') isThemeDetailLoading: boolean = false;
  @Provide('isFullScreen') isFullScreen: boolean = false;
  @Provide('isShowPandoraEditor') isShowPandoraEditor: boolean = false;
  @Provide('selectPhotoPreviewShow') selectPhotoPreviewShow: boolean = false;
  @Provide('isPhotoPickerShown') isPhotoPickerShown: boolean = false;
  @Provide('isWaitingDialog') isWaitingDialog: boolean = false;
  @Provide('roundedPlainCardSize') roundedPlainCardSize: SizeOptions = {};
  @Provide isComplainShow: boolean = false;
  @Provide onBackPressCount: number = 0;
  // @Provide('myWallpaperList') myWallpaperList: WallpaperListDataSource = new WallpaperListDataSource();
  @State isFull: boolean = false;
  @State isHybird: boolean = false;
  @State hasPrePage: boolean = false;
  private navName: string = '';
  private session: UIExtensionContentSession | undefined = undefined;
  private source: string = '';
  private isNeedDestroy: boolean | undefined = true;
  private themeHomeStamp: string = '';
  private themeWindowStage: window.WindowStage | undefined;
  @State bgPixelMap: image.PixelMap | null = null;
  @State @Watch('updateIsHideBackButton') isSettingSplit: boolean = false;
  @State @Watch('updateIsHideBackButton') isFromSearch: boolean = false;
  @State @Watch('updateIsHideBackButton') isPadInPCMode: boolean = false;
  @Provide('isHideBackButton') isHideBackButton: boolean = false;
  @Provide('isShowAgreementDialog') isShowAgreementDialog: boolean = false;
  @Provide('agreementDialogProxy') agreementDialogProxy: UIExtensionProxy | undefined = undefined;
  @State isSettingPage: boolean = false

  public updateIsHideBackButton(): void {
    this.isHideBackButton = this.isSettingSplit || this.isFromSearch || this.isPadInPCMode;
  }

  @Builder
  public PageMap(name: string) {
    if (name === Constants.WALLPAPER_SETTING) {
      ShowWallpaperPage({
        selectImageFromGallery: () => {
          this.selectImageFromGallery();
        },
        pickWallpaperToEdit: (imageUrl: string, wallpaperStyle: ImageShowStyle) => {
          this.pickWallpaper(imageUrl, wallpaperStyle)
        },
        pushScreenSettingPage: () => {
          this.pageInfos.pushPath({name: Constants.SCREEN_SETTING})
        }
      })
    } else if (name === Constants.WALLPAPER_EDITOR) {
      WallpaperEditPage({
        bgPixelMap: this.bgPixelMap,
        imageUrl: this.selectedImageUri,
        hasPreView: this.hasPrePage,
        wallpaperStyle: this.wallpaperStyle,
        setWallpaper: async (uri: string, imagePicelMap: image.PixelMap, wallpaperType: WallPageType): Promise<boolean> => {
           let isBack: boolean = await this.setWallpaper(uri, imagePicelMap, wallpaperType);
           return isBack
        }
      })
    } else if (name === Constants.WALLPAPER_PICKER) {
      ShowWallpaperPage({
        selectImageFromGallery: () => {
          this.selectImageFromGallery();
        },
        pickWallpaperToEdit: (imageUrl: string, wallpaperStyle: ImageShowStyle) => {
          this.pickWallpaper(imageUrl, wallpaperStyle)
        },
        pushScreenSettingPage: () => {
          this.pageInfos.pushPath({name: Constants.SCREEN_SETTING})
        },
        clickClose: () => {
          this.session?.sendData({ 'hiddenLockWallpaper': true })
        }
      })
    } else if (name === Constants.THEME_GALLERY) {
      ShowWallpaperPage({
        selectImageFromGallery: () => {
          this.selectImageFromGallery();
        },
        pickWallpaperToEdit: (imageUrl: string, wallpaperStyle: ImageShowStyle) => {
          this.pickWallpaper(imageUrl, wallpaperStyle)
        },
        pushScreenSettingPage: () => {
          this.pageInfos.pushPath({name: Constants.SCREEN_SETTING})
        }
      })
    } else if (name === Constants.SCREEN_SETTING) {
      ScreenSetting({
        backAction: () => {
          this.pageInfos.pop()
        }
      })
    }
  }

  public async aboutToAppear() {
    Log.info(TAG, `aboutToAppear, this.isNeedDestroy = ${this.isNeedDestroy} this.navName = ${this.navName}`);
    // this.pageInfos.pushPath({
    //   name: Constants.WALLPAPER_SETTING,
    // });

    // HiSysEventUtil.reportDataSize();
    //创建json文件
    await ImageUtils.initJsonFile(this.context)
    Log.info(TAG, 'aboutToAppear');
    this.inspector.on('layout', () => {
      AppStorage.setOrCreate('rootNavigationWidth', px2vp(componentUtils.getRectangleById('ThemeHome').size.width));
    });
    // accessHelper.initAccessibilityModeListener();
    if (this.isAIGCNotice()) {
      Log.info(TAG, 'is AIGC Notice');
      return;
    }
    // let params: WantParams | undefined = LocalStorage.getShared()?.get<WantParams>('params');
    let params: ESObject | undefined = LocalStorage.getShared()?.get<ESObject>('params');
    this.isNeedDestroy = LocalStorage.getShared()?.get<boolean>('isNeedDestroy');
    this.navName = this.getParam(params, (param: ESObject) => param.nav as string, '');
    this.isHybird = this.getParam(params,  (param: ESObject) => param.isHybird as boolean, false)
    Log.info(TAG, `this.isHybird: ${this.isHybird}---${JSON.stringify(params)}`)
    Log.info(TAG, `aboutToAppear, this.isNeedDestroy = ${this.isNeedDestroy} this.navName = ${this.navName}`);
    this.isSettingPage = this.navName === Constants.WALLPAPER_SETTING
    this.session = this.getParam(params, (param: ESObject) => param.session as UIExtensionContentSession, undefined);
    // await displayHelper.init(this.session?.getUIExtensionHostWindowProxy());
    this.pageInfos.pushPath({
      name: this.navName ?? '',
      param: params,
      isEntry: this.isSettingIntentPage(this.navName),
    }, this.isNeedNavBarAnimation(this.navName));
    this.onWindowSizeChange();
    this.sizeChangeCallback();
    this.session?.setReceiveDataCallback(async (data: Record<string, Object>) => {
      if (data?.requestId === 'selectImageFromGallery') {
        if (await this.modifyWallpaperDisable()) {
          return
        }
        this.selectedImageUri = data!.uri as string;
        this.hasPrePage = true
        Log.info(TAG, 'get wallpaper------' + this.selectedImageUri);
        this.bgPixelMap = await ImageUtils.convertUriToPixelMap(this.selectedImageUri);
        this.pageInfos.pushPath({ name: Constants.WALLPAPER_EDITOR })
      }
    })
  }

  async savePixelMapWithPacker(pixelMap: PixelMap, outputPath: string, format: string = 'image/jpeg', quality: number = 95): Promise<void> {
  try {
    const imagePacker = image.createImagePacker()
    if (!imagePacker) {
      throw new Error('ImagePacker creat error')
    }
    const packOpts: image.PackingOption = {
      format: format,
      quality: quality
    }
    const packedData = await imagePacker.packing(pixelMap, packOpts)
    const file = fileIo.openSync(
      outputPath,
      fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.TRUNC
    )
    fileIo.writeSync(file.fd, packedData)
    fileIo.closeSync(file)
    imagePacker.release()
  } catch (error) {
    let err = error as BusinessError;
    Log.error(TAG, `ThemeComponentExtAbility onSessionDestroy err:${err?.message}--${err?.code}`);
  }
}

  async saveMediaToSandbox(mediaUri: string, fileName: string, context: common.UIAbilityContext): Promise<string> {
    try {
      Log.info(TAG, `saveMediaToSandbox start: ${mediaUri}`);

      // 1. 通过 photoAccessHelper 读取媒体文件
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      const predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('uri', mediaUri);
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
        throw new Error(`media file: ${mediaUri}`);
      }
      const asset = await fetchResult.getFirstObject();
      // 获取文件大小
      let fileSize = asset.get(photoAccessHelper.PhotoKeys.SIZE) as number;

      // 如果无法从元数据获取大小，通过 fd 获取
      if (fileSize === 0 || fileSize === undefined) {
        Log.warn(TAG, 'error ');
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
      Log.info(TAG, `read success: ${readLen}`);
      // 3. 保存到应用沙箱
      const sandboxDir = context.filesDir; // 获取沙箱文件目录
      const savePath = `${sandboxDir}/${fileName}`;
      // 打开目标文件（如果不存在会创建，存在则覆盖）
      const saveFile = fs.openSync(savePath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      // 写入数据
      const writeLen = fs.writeSync(saveFile.fd, arrayBuffer);
      // 关闭目标文件
      fs.closeSync(saveFile);
      Log.info(TAG, `save success: ${savePath}，size: ${writeLen}`);
      return savePath;
    } catch (error) {
      Log.info(TAG, `error:${error}`);
      return error?.message;
    }
  }

  async copyFileToSandbox(sourcePath: string, fileName: string): Promise<string> {
  try {
    const context = this.getUIContext().getHostContext() as common.Context;
    const sandboxDir = context.filesDir;
    const targetPath = `${sandboxDir}/${fileName}`;
    const sourceFile = fs.openSync(sourcePath, fs.OpenMode.READ_ONLY);
    const targetFile = fs.openSync(targetPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.copyFileSync(sourceFile.fd, targetFile.fd, 0);
    fs.closeSync(sourceFile);
    fs.closeSync(targetFile);
    Log.info(TAG, `copyfile success: ${targetPath}`);
    return targetPath;
  } catch (err) {
    const error = err as BusinessError;
    Log.error(TAG, `copyfile error: ${error.code}, ${error.message}`);
    return "";
  }
}

  private isSettingIntentPage(navName: string): boolean {
    // const contextObject: object | undefined = GlobalContext.getContext().getObject(Constants.THEME_EDITOR_CONTEXT);
    const contextObject: object | undefined = AppStorage.get('theme_editor_context');
    if (!contextObject) {
      Log.error(TAG, `isSettingIntentPage, contextObject is undefined`);
      return false;
    }
    const context: common.ExtensionContext = contextObject as common.ExtensionContext;
    if (context?.extensionAbilityInfo?.name && context.extensionAbilityInfo.name !== SETTING_EXTENSION_ABILITY_NAME) {
      return false;
    }
    return true
  }

  onBackPress(): boolean | void {
    this.onBackPressCount++;
  }

  private isNeedNavBarAnimation(navName: string): boolean {
    // const contextObject: object | undefined = GlobalContext.getContext().getObject(Constants.THEME_EDITOR_CONTEXT);
    const contextObject: object | undefined = AppStorage.get('theme_editor_context');

    const context: common.ExtensionContext = contextObject as common.ExtensionContext;
    if (context?.extensionAbilityInfo?.name && context.extensionAbilityInfo.name !== SETTING_EXTENSION_ABILITY_NAME) {
      return false;
    }
    return true
  }

  private isAIGCNotice(): boolean {
    let aigcParams: AigcParams | undefined = LocalStorage.getShared()?.get<AigcParams>('params');
    let startMode: number = aigcParams?.startMode as number;
    let editorId: string = aigcParams?.editorId as string;
    let status: number = aigcParams?.status as number;
    let errCode: number = aigcParams?.errCode as number;
    if (editorId && editorId != '' && startMode) {
      const pandoraParam: AigcParams = {
        startMode: startMode,
        editorId: editorId,
        status: status,
        errCode: errCode
      };
      // this.pageInfos.pushPath({ name: Constants.AIGC_THEME_EDITOR, param: pandoraParam }, false);
      return true;
    }
    return false;
  }

  private getParam(params: ESObject | undefined, getter: (params: ESObject) => ESObject, def: ESObject): ESObject {
    if (!params) {
      return def;
    }
    return getter(params) ?? def;
  }

  private onWindowSizeChange(): void {
    this.themeHomeStamp = Date.now().toString();
    try {
      this.session?.getUIExtensionWindowProxy().on('windowSizeChange', this.sizeChangeCallback);
    } catch (e) {
      Log.error(TAG, 'session error');
    }
  }

  private sizeChangeCallback = async (): Promise<void> => {
    try {
      let windowRect = this.session?.getUIExtensionHostWindowProxy().properties.uiExtensionHostWindowProxyRect;
      if (windowRect) {
        this.isSettingSplit = true;

        Log.info(TAG, `isSettingSplit: ${this.isSettingSplit}`);
      }
    } catch (err) {
      Log.error(TAG, 'window getLastWindow failed');
    }
  }

  public aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear, this.navName = ${this.navName}, this.isNeedDestroy = ${this.isNeedDestroy}`);
  }


  private async modifyWallpaperDisable(): Promise<boolean> {
    if (await PCUtils.isModifyWallpaperDisable()) {
      Log.info(TAG, `modify wallpaper is disbaled,show toast`);
      try {
        promptAction.showToast({
          message: $r('app.string.disable_modify_wallpaper_tips')
        });
      } catch (e) {
        Log.error(TAG, `showToast fail, code: ${e?.code}, message: ${e?.message}`);
      }
      return true;
    }
    return false
  }

  private async selectImageFromGallery() {
    if (this.isSettingPage) {
      this.session?.sendData({ 'selectImageFromGallery': true })
    } else {
      await this.selectImageWithoutPreview()
    }

  }

  async selectImageWithoutPreview() {
  try {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    photoSelectOptions.maxSelectNumber = 1;
    photoSelectOptions.singleSelectionMode = photoAccessHelper.SingleSelectionMode.SELECT_MODE
    photoSelectOptions.isPreviewForSingleSelectionSupported = false;
    photoSelectOptions.isPhotoTakingSupported = false
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    const photoSelectResult = await photoViewPicker.select(photoSelectOptions);
    if (photoSelectResult.photoUris.length > 0) {
      if (await this.modifyWallpaperDisable()) {
        return
      }
      const uri = photoSelectResult.photoUris[0];
      this.selectedImageUri = uri;
      this.hasPrePage = true
      Log.info(TAG, 'get wallpaper' + this.selectedImageUri);
      this.bgPixelMap = await ImageUtils.convertUriToPixelMap(this.selectedImageUri);
      this.pageInfos.pushPath({ name: Constants.WALLPAPER_EDITOR })
    }

  } catch (err) {
    const error = err as BusinessError;
    Log.error(TAG, `选择图片失败, code: ${error.code}, message: ${error.message}`);
  }
}

//在壁纸页面选择壁纸
  public async pickWallpaper(imageUrl: string, wallpaperStyle: ImageShowStyle = ImageShowStyle.ImageShowStyleFitScreen) {
    if (await this.modifyWallpaperDisable()) {
      return
    }
    try {
      this.selectedImageUri = imageUrl
      // this.bgPixelMap = await ImageUtils.readLocalImage(imageUrl)
      const displayInfo = display.getDefaultDisplaySync()
      const width = displayInfo.width
      const height = displayInfo.height
      this.wallpaperStyle = wallpaperStyle
      this.hasPrePage = true;
      this.bgPixelMap = await CompleteImageAdapter.adaptImage(imageUrl, this.wallpaperStyle, width, height)
      this.pageInfos.pushPath({ name: Constants.WALLPAPER_EDITOR });
      Log.info(TAG, 'pickWallpaper to setWallpaper, go to wallpaper edit page')
    } catch (err) {

    }
  }

  notifyApplyTheme(): void {
    const option: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      isOrdered: false,
      isSticky: true
    }
    try {
      commonEventManager.publish('ts.event.theme.change', option, (error) => {
        if (error) {
          Log.error(TAG, `notifyApplyTheme error err:${error?.message}--${error?.code}`);
        } else {
          Log.info(TAG, 'notifyApplyTheme success');
        }
      });
    } catch (error) {
      Log.error(TAG, 'publish notifyApplyTheme error', error);
    }
  }

  publishRefreshWallpaperEvent(): void {
    try {
      commonEventManager.publish(Constants.REFRESH_WALLPAPER, (error) => {
        if (error) {
          Log.error(TAG,`publishRefreshWallpaperEvent error name:${error?.name} message:${error?.message} stack:${error?.stack}`);
        } else {
          Log.info(TAG, 'publishRefreshWallpaperEvent success');
        }
      });
    } catch (error) {
      let err = error as BusinessError;
      Log.error(TAG, `publish publishRefreshWallpaperEvent error:
                      name:${err?.name} message:${err?.message} stack:${err?.stack}` );
    }
  }

  private async setWallpaper(uri: string, imagePicelMap: image.PixelMap, wallpaperType: WallPageType): Promise<boolean> {
    const lockFileName = `wallpaper_lock_image.webp`;
    const unlockFileName = `wallpaper_unlock_image.webp`;
    Log.info(TAG, `setWallpaper----${imagePicelMap}----${imagePicelMap === null}`)
    if (!imagePicelMap || imagePicelMap === null) {
      promptAction.showToast({
        message: $r('app.string.image_decoding_failure'),
      });
      return false
    }
    switch (wallpaperType) {
      case WallPageType.WALLPAGETYPE_ALL:
        await this.saveImageToLocalPath(uri, imagePicelMap, lockFileName, wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN)
        await this.saveImageToLocalPath(uri,imagePicelMap, unlockFileName, wallpaper.WallpaperType.WALLPAPER_SYSTEM)
        break;
      case WallPageType.WALLPAGETYPE_LOCK:
        await this.saveImageToLocalPath(uri, imagePicelMap, lockFileName, wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN)
        break;
      case WallPageType.WALLPAGETYPE_DESKTOP:
        await this.saveImageToLocalPath(uri, imagePicelMap, unlockFileName, wallpaper.WallpaperType.WALLPAPER_SYSTEM)
        break;
    }
    const path = await ImageUtils.saveImage(uri, this.context)
    PersistentStorage.persistProp(Constants.LOCAL_WALLPAPER, path)
    const jsonPath = await ImageUtils.initJsonFile(this.context)
    const dataList = await ImageUtils.readJsonFile(jsonPath)
    await ImageUtils.addData(jsonPath, dataList, path)
    this.publishRefreshWallpaperEvent();
    this.notifyApplyTheme()
    return true
  }

  async saveImageToLocalPath(uri: string, imagePixelMap: PixelMap, fileName: string, wallpaperType: wallpaper.WallpaperType) {
    let localPath: string = ''
    let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    try {
      const sandboxDir = uiContext.filesDir; // 获取沙箱文件目录
      localPath = `${sandboxDir}/${fileName}`;
      await this.savePixelMapWithPacker(imagePixelMap, localPath)
      Log.info(TAG, `save success: ${localPath}`);
      // 验证文件是否存在
      const stat = fs.statSync(localPath);
      Log.info(TAG, `file size: ${stat.size}`);
      let wallpaperInfos: wallpaper.WallpaperInfo[] = [];
      wallpaperInfos.push({
        foldState: wallpaper.FoldState.NORMAL,
        rotateState: wallpaper.RotateState.PORTRAIT,
        source: localPath
      });
      await wallpaper.setAllWallpapers(wallpaperInfos, wallpaperType)
    } catch (error) {
      Log.error(TAG, 'save error:', error);
    }
  }

  public build() {
    Navigation(this.pageInfos) {
    }
    .id('ThemeHome')
    .key('ThemeHome')
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
    .borderRadius(this.isHybird ? { topLeft: 40, topRight: 40 } : 0)
    .clip(this.isHybird ? true : false)
    .onDisAppear(() => {
      try {
        this.session?.sendData({ 'hiddenLockWallpaper': true })
      } catch (err) {
        const error = err as BusinessError;
        Log.error(TAG, `onDisAppear sendData error: ${error.code}, ${error.message}`);
      }
    })
  }
}
