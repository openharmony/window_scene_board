/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  SymbolGlyphModifier
} from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { HdsNavigation, HdsNavigationAttribute } from '@kit.UIDesignKit';
import { DesktopIntelligentSettingPage } from './desktopSetting/DesktopIntelligentSettingPage';
import DesktopSetting from './desktopSetting/DesktopSettingPage';
import { OUTER_DESKTOP_EDIT, OuterDesktopEditPage } from './desktopSetting/OuterDesktopEditPage';
import { MAGIC_SCREEN, MagicScreenHome } from './MagicSreenHome';
import { SUB_SCREEN_THEME, SubScreenTheme } from './SubScreenTheme';
import { AigcParams } from '../uiability/AigcAbility';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import EditWallpaper from './EditWallpaper';
import { WallPaper, WallPaperInfo } from "@ohos/themeservicekit";
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { ThemeInfoAdapter } from '../themeInfoAdapter/ThemeInfoAdapter';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';
import { picker } from '@kit.CoreFileKit';
import { Constants } from '../constants/wallpaperPathConstants';
import { ShowWallpaperPage } from './ShowWallpaperPage'
import { image } from '@kit.ImageKit';
import { WallpaperEditPage } from './WallpaperEditPage';
import { commonEventManager, wallpaper } from '@kit.BasicServicesKit';
import { ImageUtils } from '../utils/ImageUtils';
import { LogUtil } from '@ohos/lottie';

const TAG: string = 'ThemeHome';
const INTELLIGENT_SETTING_PAGE: string = 'intelligentSettingPage';
const SETTING_EXTENSION_ABILITY_NAME: string = 'SettingThemeComponentExtAbility';
const THEME_APP_BUNDLE: string = 'com.ohos.thememanager';
const FONT_CREATION_PRIVACY_PAGE: string = 'FontCreationPrivacyPage';

@Entry
@Component
struct ThemeHome {
  private selectedImageUri: string = '';
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
  @State hasPrePage: boolean = false;
  private navName: string = '';
  private session: UIExtensionContentSession | undefined = undefined;
  private source: string = '';
  private isNeedDestroy: boolean | undefined = true;
  private themeHomeStamp: string = '';
  private themeWindowStage: window.WindowStage | undefined;
  @State bgPixelMap: image.PixelMap | Resource | null = null;
  @State @Watch('updateIsHideBackButton') isSettingSplit: boolean = false;
  @State @Watch('updateIsHideBackButton') isFromSearch: boolean = false;
  @State @Watch('updateIsHideBackButton') isPadInPCMode: boolean = false;
  @Provide('isHideBackButton') isHideBackButton: boolean = false;
  @Provide('isShowAgreementDialog') isShowAgreementDialog: boolean = false;
  @Provide('agreementDialogProxy') agreementDialogProxy: UIExtensionProxy | undefined = undefined;

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
        pickWallpaperToEdit: (imageUrl: Resource) => {
          this.pickWallpaper(imageUrl)
        }
      })
    } else if (name === Constants.WALLPAPER_EDITOR) {
      WallpaperEditPage({
        bgPixelMap: this.bgPixelMap,
        imageUrl: this.selectedImageUri,
        hasPreView: this.hasPrePage,
        setWallpaper: (uri: string): void => {
          this.setWallpaper(uri);
        }
      })
    } else if (name === Constants.WALLPAPER_PICKER) {
      ShowWallpaperPage({
        selectImageFromGallery: () => {
          this.selectImageFromGallery();
        },
        pickWallpaperToEdit: (imageUrl: Resource) => {
          this.pickWallpaper(imageUrl)
        }
      })
    } else if (name === Constants.THEME_GALLERY) {
      ShowWallpaperPage({
        selectImageFromGallery: () => {
          this.selectImageFromGallery();
        },
        pickWallpaperToEdit: (imageUrl: Resource) => {
          this.pickWallpaper(imageUrl)
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
    Log.info(TAG, `aboutToAppear, this.isNeedDestroy = ${this.isNeedDestroy} this.navName = ${this.navName}`);
    this.session = this.getParam(params, (param: ESObject) => param.session as UIExtensionContentSession, undefined);
    // await displayHelper.init(this.session?.getUIExtensionHostWindowProxy());
    this.pageInfos.pushPath({
      name: this.navName ?? '',
      param: params,
      isEntry: this.isSettingIntentPage(this.navName),
    }, this.isNeedNavBarAnimation(this.navName));
    this.onWindowSizeChange();
    this.sizeChangeCallback();
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
    LogUtil.info(`copyfile success: ${targetPath}`);
    return targetPath;
  } catch (err) {
    const error = err as BusinessError;
    LogUtil.error(`copyfile error: ${error.code}, ${error.message}`);
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
    // //全局搜索桌面设置场景，侧滑直接返回全搜
    // if (navName === Constants.DESKTOP_SETTING_PAGE) {
    //   return true;
    // }
    if (context?.extensionAbilityInfo?.name && context.extensionAbilityInfo.name !== SETTING_EXTENSION_ABILITY_NAME) {
      return false;
    }
    // return navName === Constants.WALLPAPER_PICKER || navName === Constants.ICON_PICKER ||
    //   navName === Constants.THEME_PICKER || navName === Constants.FONT_PICKER ||
    //   navName === Constants.SETTINGS_THEME_PAGE || navName === Constants.MY_WALLPAPER_EDIT ||
    //   navName === Constants.MY_WALLPAPER_EDIT_DIGITAL_CLOCK || navName === Constants.MY_WALLPAPER_EDIT_ART_SIGNATURE ||
    //   navName === Constants.MY_WALLPAPER_EDIT_LOCK_CARD;
    return true
  }

  private isSettingSelfDrawPage(navName: string): boolean {
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
    // return navName === Constants.WALLPAPER_PICKER || navName === Constants.ICON_PICKER ||
    //   navName === Constants.THEME_PICKER || navName === Constants.FONT_PICKER ||
    //   navName === Constants.SETTINGS_THEME_PAGE;
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
    // return navName === Constants.WALLPAPER_PICKER || navName === Constants.ICON_PICKER ||
    //   navName === Constants.THEME_PICKER || navName === Constants.FONT_PICKER ||
    //   navName === Constants.SETTINGS_THEME_PAGE;
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

  // private getParam<T>(params: WantParams | undefined, getter: (params: WantParams) => Nullable<T>, def: T): T {
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
      // if (this.source === THEME_APP_BUNDLE || DeviceHelper.isPC()) {
      //   return;
      // }
      let windowRect = this.session?.getUIExtensionHostWindowProxy().properties.uiExtensionHostWindowProxyRect;
      if (windowRect) {
        let windowWidth: number = windowRect.width;
        let windowHeight: number = windowRect.height;
        let displayWidth: number = display.getDefaultDisplaySync().width;
        let displayHeight: number = display.getDefaultDisplaySync().height;
        // this.isPadInPCMode = await SmallWindowHelper.checkPadIsInPCMode();
        // if (windowWidth !== displayWidth && (!SmallWindowHelper.checkSmallWindow() || windowHeight !== displayHeight &&
        // SmallWindowHelper.checkWindowSplit())) {
        //   this.isSettingSplit = true;
        // } else {
        //   this.isSettingSplit = false;
        // }
        this.isSettingSplit = true;

        Log.info(TAG, `isSettingSplit: ${this.isSettingSplit}`);
      }
    } catch (err) {
      Log.error(TAG, 'window getLastWindow failed');
    }
  }

  public aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear, this.navName = ${this.navName}, this.isNeedDestroy = ${this.isNeedDestroy}`);
    // try {
    //   this.session?.getUIExtensionWindowProxy().off('windowSizeChange', this.sizeChangeCallback);
    // } catch (e) {
    //   Log.error(TAG, 'session error');
    // }
    // displayHelper.destroy();
    //
    // // 特殊场景，分栏设备的主题详情、壁纸编辑、个性化主题自定义、字体详情
    // const exceptScene: boolean = this.navName === Constants.WALLPAPER_EDITOR ||
    //   this.navName === Constants.THEME_DETAIL || this.navName === Constants.THEME_PERSONALIZE ||
    //   this.navName === Constants.FONT_DETAIL || this.navName === Constants.LOCK_PERSONALIZE_PAGE;
    // // 非分栏设备，直接取消注册
    // // 分栏设备 以上几个页面 无需取消注册
    // // 分栏设备 其他页面 取消注册
    // if (exceptScene && DeviceHelper.isSettingSplitProduct()) {
    //   return;
    // }
    // accessHelper.unregisterAccessibilityModeListener();
  }

  // 将图片URI转换为PixelMap（用于背景显示）


  private async selectImageFromGallery() {
    try {
      // 1. 创建图库选择器实例
      const photoPicker = new picker.PhotoViewPicker();
      // 2. 配置选择参数（选单张图片）
      const selectOptions = new picker.PhotoSelectOptions();
      selectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE; // 只选图片
      selectOptions.maxSelectNumber = 1; // 最多选1张
      // 3. 拉起系统图库，等待用户选择
      const result = await photoPicker.select(selectOptions);
      // 4. 处理选择结果（拿到图片URI）
      if (result.photoUris && result.photoUris.length > 0) {
        this.selectedImageUri = result.photoUris[0];
        this.hasPrePage = true
        Log.info(TAG, 'get wallpaper' + this.selectedImageUri);
        this.bgPixelMap = await ImageUtils.convertUriToPixelMap(this.selectedImageUri);
        this.pageInfos.pushPath({ name: Constants.WALLPAPER_EDITOR })
        // // 5. 调用设置壁纸方法
        // await this.setWallpaper(this.selectedImageUri);
      } else {
        // hilog.warn(0x0000, 'Wallpaper', '用户取消了图库选择');
      }
    } catch (err) {
      // hilog.error(0x0000, 'Wallpaper', '拉起图库失败：%{public}s', JSON.stringify(err));
    }
  }

//在壁纸页面选择壁纸
  public pickWallpaper(imageUrl: Resource) {
    this.bgPixelMap = imageUrl;
    this.hasPrePage = true;
    this.pageInfos.pushPath({ name: Constants.WALLPAPER_EDITOR });
    Log.info(TAG, 'pickWallpaper to setWallpaper, go to wallpaper edit page')
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
          console.log('notifyApplyTheme error', error);
        } else {
          console.log('notifyApplyTheme success');
        }
      });
    } catch (error) {
      console.log('publish notifyApplyTheme error', error);
    }
  }

  private async setWallpaper(uri: string) {
    let localPath: string = ''
    let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    const fileName = `wallpaper_image.webp`;
    try {
      if (uri.startsWith('datashare://media/') || uri.startsWith('file://media/')) {
        localPath = await this.saveMediaToSandbox(uri, fileName, uiContext);
      } else {
        localPath = await this.copyFileToSandbox(uri, fileName)
      }
      console.log(`save success: ${localPath}`);
      // 验证文件是否存在
      const stat = fs.statSync(localPath);
      console.log(`file size: ${stat.size}`);
      let wallpaperInfos: wallpaper.WallpaperInfo[] = [];
      wallpaperInfos.push({
        foldState: wallpaper.FoldState.NORMAL,
        rotateState: wallpaper.RotateState.PORTRAIT,
        source: localPath
      });
      await wallpaper.setAllWallpapers(wallpaperInfos, wallpaper.WallpaperType.WALLPAPER_SYSTEM)
      this.notifyApplyTheme()

    } catch (error) {
      console.error('save error:', error);
    }
  }

  public build() {
    Navigation(this.pageInfos) {
    }
    .id('ThemeHome')
    .key('ThemeHome')
    .backgroundColor(Color.Red)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .hideNavBar(true)
    .mode(NavigationMode.Stack)
    // if (DeviceHelper.isPC()) {
    //   Navigation(this.pageInfos) {
    //   }
    //   .id('ThemeHome')
    //   .key('ThemeHome')
    //   .backgroundColor(this.isFull && (this.navName !== ThemeHome.THEME_GALLEY) ?
    //   $r('sys.color.ohos_id_color_titlebar_sub_bg')
    //     : $r('app.color.transparent'))
    //   .hideTitleBar(true)
    //   .navDestination(this.PageMap)
    //   .hideNavBar(this.isSettingSplit || this.isFromSearch || this.isPadInPCMode)
    //   .mode(NavigationMode.Stack)
    // } else {
  //   Navigation(this.pageInfos) {
  //   }
  //   .id('ThemeHome')
  //   .key('ThemeHome')
  //   .mode(NavigationMode.Auto)
  //   // .backgroundColor(this.isFull && (this.navName !== ThemeHome.THEME_GALLEY) ?
  //   // $r('sys.color.ohos_id_color_titlebar_sub_bg')
  //   //   : $r('app.color.transparent'))
  //   .backgroundColor(Color.Red)
  //   .hideTitleBar(true)
  //   .navDestination(this.PageMap)
  //   .hideNavBar(this.isSettingSplit || this.isFromSearch || this.isPadInPCMode)
  //   .mode(NavigationMode.Stack)
  // }
  // }
  }
}
