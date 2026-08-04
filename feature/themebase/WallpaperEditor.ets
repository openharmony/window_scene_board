/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2025. All rights reserved.
 */

import { DeviceImpl, deviceManager, WearableAbility } from '@dmslibrary/wear-service-client';
import { ContextUtil } from '@dmslibrary/wear-service-client/src/main/ets/utils/ContextUtil';
import { CamMoverPreview, CamMoverService } from '@hw-hmos/cammover/Index';
import {
  CamMoverCompositionConfig,
  CamMoverConfig,
  CamMoverRes,
} from '@hw-ohos/cammover/src/main/ets/model/CamMoverRes';
import {
  Adapter,
  AnyClock,
  ClockLayout,
  ColorStyle,
  ColorStyleInputData,
  IDConstants,
  LayoutEditManager,
  LayoutGridTool,
  MainColor,
  ScreenLockEditPanel,
} from '@hw-ohos/screenlockedit/Index';
import { ClickState } from '@hw-hmos/screenlockedit/src/main/ets/3rd/LayoutGridTool';
import { slStateHelper } from '@hw-hmos/screenlockedit/src/main/ets/screenlockstate/model/helper/SlStateHelper';
import { ScreenLockEditUtils } from '../utils/ScreenLockEditUtils';
import { ColorType } from '@hw-hmos/screenlockedit/src/main/ets/edit/editsheet/models/MainColor';
import { slEditorHelper } from '@hw-hmos/screenlockedit/src/main/ets/edit/editsheet/utils/EditSheetHelper';
import { CardLayout } from '@hw-hmos/screenlockedit/src/main/ets/screenlockform/vm/ScreenLockFormViewModel';
import { LockscreenFormConfig } from '@hw-hmos/screenlockedit/src/main/ets/TsIndex';
import { displaySync } from '@kit.ArkGraphics2D';
import {
  componentUtils,
  inspector,
  promptAction,
  PromptAction,
  UIContext,
  UIInspector
} from '@kit.ArkUI';
import { emitter, screenLock } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { HdsNavDestination } from '@kit.UIDesignKit'; // HdsNavDestinationAttribute不可删
import common from '@ohos.app.ability.common';
import base from '@ohos.base';
import commonEventManager from '@ohos.commonEventManager';
import display from '@ohos.display';
import { Constants } from 'common/src/main/ets/utils/Contants';
import FileUtil from 'common/src/main/ets/utils/FileUtil';
import { Log } from 'common/src/main/ets/utils/Log';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import {
  LockscreenConfig, LockscreenForm
} from 'themeservice/src/main/ets/themeservice/model/ThemeInfoNew';
import { WallPaper, WallPaperInfo } from 'themeservice/src/main/ets/themeservice/model/WallPaper';
import { EventId } from 'common/src/main/ets/model/constant/EventId';
import { ThemeInfoAdapter } from '../data/ThemeInfoAdapter';
import { LockScreenData } from '../model/LockScreenData';
import { WantParams } from '../model/WantParams';
import { accessHelper } from '../utils/AccessibilityHelper';
import AnimationUtil from 'common/src/main/ets/model/utils/AnimationUtil';
import { CollectionUtil } from 'common/src/main/ets/model/utils/CollectionUtil';
import { DeviceHelper } from '../utils/DeviceHelper';
import { fontScaleManager } from 'common/src/main/ets/model/utils/fontScaleManager';
import { FontScaleState } from 'common/src/main/ets/model/utils/fontScaleState';
import { HistoryWallpaperUtil } from '../utils/HistoryWallpaperUtil';
import {
  ApplyBlurType,
  ApplyTypes,
  ChangeClickType,
  FloatingButtonType,
  HiSysEventUtil,
  WallpaperBlurType,
  WallpaperChangeInterface,
  WallpaperEditEntrance,
} from '../utils/HiSysEventUtil';
import { HiTraceUtil } from '../utils/HiTraceUtil';
import { NavigationUtil } from 'common/src/main/ets/model/utils/NavigationUtil';
import { PickerUtil } from '../utils/PickerUtil';
import PixelMapUtil, { IPixelMapReadingOptions } from '../utils/PixelMapUtil';
import { ResourceManager } from 'common/src/main/ets/model/utils/ResourceManager';
import ShareTransitionUtil from '../utils/ShareTransitionUtil';
import { SmallWindowHelper } from 'common/src/main/ets/model/SmallWindowHelper';
import { StringUtil } from '../utils/StringUtil';
import { ThemeResourceController } from '../utils/ThemeResourceController';
import {
  ImageSaliency,
  WallpaperAttr,
  WallpaperRectData,
  WallpaperSourceType,
  WallpaperUtil,
} from '../utils/WallpaperUtil';
import { WallpaperQualifier, WallpaperWriter } from '../utils/WallpaperWriter';
import AesManager from './aesthtic/AesManager';
import { AesUiSwitchSet } from './aesthtic/AesUiSwitchSet';
import ApplySheet from './applydialog/ApplySheet';
import { ClockArtStyleHelper } from './clock/ClockArtStyleHelper';
import ClockDataManager from './clock/ClockDataManager';
import { ClockParamAdapter } from './clock/ClockParamAdapter';
import { ClockUiSwitchSet } from './clock/ClockUiSwitchSet';
import { DesktopParam, DesktopPreviewColorHelper } from './desktopreview/DesktopPreviewHelper';
import { CacheManger } from './editor/cache/CacheManger';
import { DialogUtil } from './editor/common/utils/DialogUtil';
import { SelectedInfo } from './editor/common/utils/TabUtils';
import ApplyPreviewDialog from './editor/view/ApplyPrewiewDialog';
import EditWallpaper from './EditWallpaper';
import { FILE_MANAGER_BUNDLE, WallpaperExternalHelper } from './external/WallpaperExternalHelper';
import FloatingButtonGroup from './FloatingButtonGroup';
import { LoadingDialog } from './LoadingDialog';
import { AnyRect } from 'common/src/main/ets/model/utils/AnyRect';
import { ClockChange } from 'common/src/main/ets/model/ClockChange';
import { WallpaperChange } from './model/WallpaperChange';
import { WallpaperEditorParams } from './model/WallpaperEditorParams';
import { WallpaperProp } from './model/WallpaperProp';
import QualifierManager, { WallpaperInfoParams } from './QualifierManager';
import { RippleEffect } from './RippleEffect';
import WallpaperFileManager, { MultiWallpaperConfigParams, SingleThemeConfigParams } from './WallpaperFileManager';
import { ComStUtil } from '../utils/ComStUtil';
import { SubScreenHelper } from './watch/SubScreenHelper';
import { WatchFaceHelper } from './watch/WatchFaceHelper';
import { UIExtensionPreloadUtil } from '../utils/UIExtensionPreloadUtil';
import { BackEventController } from './editor/controller/BackEventController';
import { PickerRecoveryController } from '../components/picker/recovery/PickerRecoveryController';
import { EditState } from '@hw-hmos/screenlockedit/src/main/ets/manager/KeyguardEditStateMgr';
import { ScreenLockViewModel } from './vm/ScreenLockViewModel';
import { ViewModelProvider } from './vm/ViewModelProvider';
import { RefreshClockData, RefreshWallpaperBasicData } from './vm/refreshdata/RefreshData';
import { createWallpaperContext, WallpaperContext } from './WallpaperContext';
import { ThemeUtils } from '../utils/ThemeUtils';
import { ColorRenewalUtil } from '../multiColorRenewal/ColorRenewalUtil';
import { EnterWallpaperEditorParam } from './model/EnterWallpaperEditorParam';
import { HashMap } from '@kit.ArkTS';
import { AUTO_PICKER } from '../components/picker/WallpaperPickerContent';
import { ScreenLockEditorPageVm } from './vm/ScreenLockEditorPageVm';
import { ScreenLockEditorPageCtlData } from './model/ScreenLockEditorPageCtlData';
import { ScreenLockEditorSpecialParams } from './model/ScreenLockEditorSpecialParams';
import EditArtSignButtonView from '@hw-hmos/screenlockedit/src/main/ets/edit/EditArtSignButtonView';
import lazy { HdsMaterialManager } from '../utils/HdsMaterialManager';

const TAG: string = 'WallpaperEditor';
const RES_MGR = ResourceManager.getInstance();
const CAMMOVER_SERVICE = CamMoverService.getInstance();
const DIALOG_OFFSET: number = 0;
const POSITION_X_MAX: number = 2;
const POSITION_X_MIN: number = 1;
const POSITION_Y_MIN: number = 0;

export const CLOCK_DEFAULT_INSETS_H: number = 24;

export const CLOCK_DEFAULT_INSETS_TOP: number = 99;

export const CLOCK_DEFAULT_INSETS_BOTTOM: number = 128;

export const CLOCK_STATUS_BAR_HEIGHT: number = 39;

const CAMERA_MOVER_EXPAND_RATE: number = 0.1;
const CAMERA_MOVER_EXPAND_PERCENT: number = CAMERA_MOVER_EXPAND_RATE * 100;

const IMAGE_DECODING_FAILED_DURATION: number = 3000;
const WALLPAPER_EDITOR_ENTER: string = 'WALLPAPER_EDITOR_ENTER';
const WALLPAPER_EDITOR_SET_WALLPAPER: string = 'WALLPAPER_EDITOR_SET_WALLPAPER';
const WALLPAPER_EDITOR_CAMMOVER_INIT: string = 'WALLPAPER_EDITOR_CAMMOVER_INIT';

const APPLY_TIME: number = 10000;
const DISAPPEAR_TIME: number = 3000;

// 聚焦取消按钮的延迟
const TOGGLE_FOCUS_DELAY: number = 300;

const QUIT_TIME: number = 500;
const SCREENLOCKEDIT_QUIT_TIME = 600;
const LOAD_DELAY: number = 100;
const THEME_APP_BUNDLE: string = 'com.ohos.app.thememanager';
const PHOTO_APP_BUNDLE: string = 'com.ohos.photos';
const AI_APP_BUNDLE: string = '';
const THEME_APP_MODE: string = 'mode';
const WINDOW_FLOATING: number = 4;
const WINDOW_SPLIT_SCREEN: number = 5;
const MAX_WIDTH: number = 6000;
const SCALE_ORIGIN: number = 1;
const WIDTH_INDEX: number = 0;
const HEIGHT_INDEX: number = 1
const MAIN_COLOR_SCALE = 0.9;
const SHOW_EDITOR_TOP_BUTTON: string = 'showEditorTopButton';
const SCB_SCREEN_LOCK: string = 'com.ohos.sceneboard.ScreenLock';
const SCREEN_LOCK_WALLPAPERCONTENT_DELAY = 50;
const WALLPAPER_SCALE_ENABLE: string = 'wallpaperScaleEnable';

@Component
export default struct WallpaperEditor {
  /**
   * 外部拉起源：正常跳转壁纸页面、全搜及设置搜索“我的壁纸”跳转当前壁纸页面
   * 默认值：正常跳转壁纸页面 Constants.WALLPAPER_PICKER
   * 其他值：全搜及设置搜索“我的壁纸”跳转当前壁纸页面 Constants.MY_WALLPAPER_EDIT 等
   */
  public bundleSource: string = Constants.WALLPAPER_PICKER;
  private slEditorPageVm?: ScreenLockEditorPageVm;
  @State screenLockEditorPageCtlData?: ScreenLockEditorPageCtlData = undefined;
  private screenLockSpecialParams?: ScreenLockEditorSpecialParams; // 锁屏编辑特殊参数

  private watchFaceHelper: WatchFaceHelper = new WatchFaceHelper();
  private dragFinished: boolean = false;
  private hasClockAction: boolean = false;
  private wallpaperDisplaySync: displaySync.DisplaySync = displaySync.create();
  private wallpaperExternalHelper: WallpaperExternalHelper = new WallpaperExternalHelper();
  private resolutionMap: Map<number, number[]> | undefined = undefined;
  private imageOrigin: string = '';
  private imageId: string = '';
  private originClockFont: string = '';
  private originClockStrokeColor: string | undefined = undefined;
  private originClockStyle: Nullable<ColorStyle> = undefined;
  private desktopProxy: UIExtensionProxy | undefined = undefined;
  @Provide needFreeze: boolean = false;
  @State isFromBindSheet: boolean = false;
  @State navBackgroundColor: ResourceColor = Color.Transparent;
  @StorageProp('colorMode') colorMode: ColorMode = ColorMode.LIGHT;
  @Provide isLightBG: boolean = false;
  @Provide isDarkMode: boolean = this.colorMode !== ColorMode.LIGHT;
  @State applySheetWidth: Length = '100%';
  @State applySheetHeight: Length = '100%';
  @State applySheetMargin: Length = 0;
  @State supportEdit: boolean = true; // 是否在进行时钟编辑
  @State clockWidgetEdit: boolean = false;
  @State initalWithPreview: boolean = true;
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State isImageLoaded: boolean = false;
  @State isUnfoldImageLoaded: boolean = false;
  @State isLandImageLoaded: boolean = false;
  @State isVerdeImageLoaded: boolean = false;
  @State desktopPreviewIcon: Resource = $r('app.media.ic_public_desktop_preview');
  @State desktopPreviewFont: Resource = $r('app.string.lockscreen_preview');
  @Provide private isReportedChange: boolean = false;
  @State params: WallpaperEditorParams = new WallpaperEditorParams();
  @Provide gridWidth: number = 0;
  @State text: string = '';
  @State isInProgress: boolean = true;
  @State isLoading: boolean = false;
  @State colorType: string = 'light';
  @State isAesLoading: boolean = false; // 美学计算是否进行中
  @State isAesSuccess: boolean = false; // 美学计算是否成功
  @State isThumbnailLoaded: boolean = false; // 缩略图是否加载完成
  @State isAesLoaded: boolean = false; // 美学计算是否已完成
  @State wallpaperLoaded: boolean = false;
  @State videoPreviewUri: Nullable<image.PixelMap> = undefined;
  private clockChange: ClockChange = new ClockChange();
  // 搜索跳转的时候，如果触发点阵动画触发美学推荐，判断之后需要拉起编辑面板
  private isNavToClockTabFinished: boolean = true;
  private originPixelMapReady: boolean = false;
  @State wallpaperChange: WallpaperChange = new WallpaperChange();
  @Provide isHideTopButton: boolean = false;
  @State isHideBottomButton: boolean = false;
  @State isLockScreenSelected: boolean = true;
  @State isHomeScreenSelected: boolean = true;
  @State isDesktopReady: boolean = false;
  @State isTimeout: boolean = false;
  private clearSetTimeout: number = 0;
  @Provide isBigFold: boolean = DeviceHelper.isFoldButNotSmallFoldProduct();
  @Provide isPad: boolean = DeviceHelper.isPad();
  @Provide isLand: boolean = DeviceHelper.isLandScape();
  @Provide isSuperFold: boolean = DeviceHelper.isSingleDisplaySuperFold();
  @Provide isPortrait: boolean = !this.isLand;
  @Provide isFoldExpand: boolean = DeviceHelper.isFoldExpanded();
  @Provide isBigFoldExpand: boolean = DeviceHelper.isBigFoldExpanded();
  private qualifierManager: QualifierManager = QualifierManager.getInstance();
  @Provide currentQualifier: WallpaperQualifier = this.qualifierManager.currentQualifier; // 当前设备物理状态对应的限定符
  @Provide @Watch('tabChange') tabQualifier: WallpaperQualifier =
    this.currentQualifier; // tab按钮对应的限定符，非GRL设备上此变量与current始终一致
  @Provide @Watch('watchSetQualifierOnly') isSetTabQualifierOnly: boolean = false;
  private qualifierSetting?: WallpaperQualifier = undefined;
  private clockDataManager: ClockDataManager = new ClockDataManager();
  private wallpaperFileManager: WallpaperFileManager = new WallpaperFileManager(this.qualifierManager);
  private screenLockViewModel: ScreenLockViewModel = ViewModelProvider.get(ScreenLockViewModel);
  private adapter: Adapter = this.screenLockViewModel.getLockWidgetAdapter();
  private aesManager: AesManager = new AesManager(this.qualifierManager, this.clockDataManager, this.adapter);
  private allQualifiers: WallpaperQualifier[] = this.qualifierManager.allQualifiers; // 本设备的所有限定符
  @State @Watch('readShowDesktop') isShowDesktop: boolean = false;
  @State firstBlurButton: boolean = false;
  @State secondBlurButton: boolean = false;
  @StorageProp('isAccessibilityMode') @Watch('onAccessModeChange') isAccessibilityMode: boolean = false;
  @Provide('isEditWallpaper') @Watch('isEditWallpaperChange') isEditWallpaper: boolean = false;
  @State wallpaperPixelMap?: image.PixelMap = undefined;
  private signString: string = ''; // 用于同步异壁纸间的联动属性
  // 如需修改变量名，需要同步修改clockRefresh中的条件
  @Provide @Watch('clockRefresh') clockObject: AnyClock = this.clockDataManager.baseClockObject;
  @Provide @Watch('clockRefresh') unfoldClockObject: AnyClock = this.clockDataManager.unfoldClockObject; // 双折、平板使用
  @Provide @Watch('clockRefresh') landClockObject: AnyClock = this.clockDataManager.landClockObject; // 双折、平板使用
  @Provide @Watch('formRefresh') formConfig: LockscreenFormConfig[] =
    this.clockDataManager.getFormConfig(this.tabQualifier);
  @Provide physicalScale: number = SCALE_ORIGIN; // tab状态和物理状态之间的显示比例
  @State targetRect: AnyRect = this.qualifierManager.targetRect;
  @State unfoldTargetRect: AnyRect = this.qualifierManager.unfoldTargetRect;
  @State landTargetRect: AnyRect = this.qualifierManager.landTargetRect;
  @State unfold2TargetRect: AnyRect = this.qualifierManager.unfold2TargetRect;
  @State land2TargetRect: AnyRect = this.qualifierManager.land2TargetRect;
  @Provide baseMainColor: MainColor = this.clockDataManager.baseMainColor;
  @Provide unfoldMainColor: MainColor = this.clockDataManager.unfoldMainColor;
  @Provide landMainColor: MainColor = this.clockDataManager.landMainColor;
  @State @Watch('readUnlockBlur') isLockscreenBlur: boolean = false;
  @State @Watch('readDesktopBlur') isDesktopBlur: boolean = false;
  @Provide foldState: number = DeviceHelper.FOLD_STATE_F;
  private preRotation: number = -1;
  private rotateEnableTimeId: number = -1;
  private readonly rotationDuration: number = 500;
  @State baseWallpaperProp: WallpaperProp = this.qualifierManager.baseWallpaperProp;
  @State unfoldedWallpaperProp: WallpaperProp =
    this.qualifierManager.unfoldedWallpaperProp;
  @State landWallpaperProp: WallpaperProp = this.qualifierManager.landWallpaperProp;
  @State unfolded2WallpaperProp: WallpaperProp =
    this.qualifierManager.unfolded2WallpaperProp;
  @State land2WallpaperProp: WallpaperProp = this.qualifierManager.land2WallpaperProp;
  @State isExiting: boolean = false;
  @State isVirtualEffect: boolean = false;
  private snapshotPromise: Promise<void> = Promise.resolve();
  private isFromHomeOrLock: boolean = false;
  @State @Watch('changeEdit') isMoved: boolean = false;
  @State @Watch('changeEdit') isZoomed: boolean = false;
  private isChangedPreview: boolean = false;
  @Provide isEdited: boolean = false;
  private customDialogComponentId: number = 0;
  @Provide isExpandHasFinish: boolean = false; // 点阵动效是否完成
  @State @Watch('changeFontScale') fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @Provide fontScale: number = 1.0; // Sceneboard锁屏未适配适老化，与锁屏保持一直按1.0显示
  @State private isApplySheetShow: boolean = false;
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private filesDir = this.uiContext.getApplicationContext().filesDir;
  private readonly themeAdapter: ThemeInfoAdapter = new ThemeInfoAdapter(this.uiContext);
  @Provide aesUiSwitchSet: AesUiSwitchSet = this.aesManager.aesUiSwitchSet;
  @State clockUiSwitchSet: ClockUiSwitchSet = this.clockDataManager.clockUiSwitchSet;
  @State isAnimating: boolean = false;
  @State wallpaperEditorScreenWidth: number = 0;
  @State wallpaperEditorScreenHeight: number = 0;
  @State @Watch('changeSource') source: string = '';
  exitWallpaperEditor?: () => void;
  private clockRefreshTime: number = 0;
  private clockLayoutMap: HashMap<WallpaperQualifier, number> = new HashMap();
  private hasReturn: boolean = false;
  private oldSession: UIExtensionContentSession | undefined = undefined;
  private wallpaperApplyType: ApplyTypes = ApplyTypes.DESKTOP;
  @State wallpaperThumbnailPixel?: PixelMap = undefined;
  @Provide showCMPreview: boolean = false;
  @Provide camMoverImageRect: AnyRect = new AnyRect({
    x: 0,
    y: 0,
    width: 0,
    height: 0,
    ratio: 1.0,
  });
  @Provide autoResize: boolean = true;
  @Provide enableCamMover: boolean = false;
  @Provide showCamMoverButton: boolean = false;
  @Provide isResPrepared: boolean = false;
  @State private cameraMoverSuccess: boolean = false;
  private isRendering: boolean = false;
  @State cameraMoverLockSnapShot?: PixelMap = undefined;
  @State cameraMoverHomeSnapShot?: PixelMap = undefined;
  @State isUnfold: boolean = false;
  @Provide isChange: boolean = false;
  @Provide isVerde: boolean = DeviceHelper.isNexSmallFold();
  @Provide verdeDisplayWidth: number = 0;
  @Provide verdeDisplayHeight: number = 0;
  private camMoverRes?: CamMoverRes = undefined;
  @State isStaticPhoto: boolean = false;
  @State isOffRippleEffect: boolean = false;
  @State isSlowMomentSuccess: boolean = false;
  @State isShowPopup: boolean = false;
  @Provide wallpaperEditorParams: Nullable<WallpaperEditorParams> =
    CacheManger.editorParam().get(this.tabQualifier);
  // 异壁纸设置 更换壁纸
  @Provide isChangeWallpaper: boolean = false;
  @Provide isRefreshWallpaper: boolean = false;
  private isShowTip: boolean = false;
  private shownCount: number = 0;
  private count: number = 0;
  private promptAction: PromptAction = this.getUIContext().getPromptAction();
  private screenlockSession: UIExtensionContentSession | undefined = undefined;
  private loadingController: CustomDialogController | null = new CustomDialogController({
    builder: LoadingDialog({
      loadingText: this.isScreenLockSCBSource() ? $r('app.string.apply_Lockscreen') : $r('app.string.applyWallpaper')
    }),
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: DIALOG_OFFSET },
    customStyle: true,
    autoCancel: false,
    onWillDismiss: (dismissAction: DismissDialogAction) => {
      Log.info(TAG, 'loading Dialog can not be canceled');
    },
  });
  @State private isConnectWatch: boolean = false;
  @State private isApplyWatch: boolean = false;
  @State private isApplySubScreen: boolean = false;
  @State private blurRadius: number = 150;
  @State checkIsAllowEnterFullScreenEditor: boolean = true;
  @Consume @Watch('onBackPressedChange') onBackPressCount: number;
  /**
   * 是否处于虚化拖动条滑动变化状态，true：处于滑动状态，false：处于结束状态（默认）
   */
  @State private isSliderChanging: boolean = false;
  @State rgbaPixelMap: image.PixelMap | undefined = undefined;

  @State isLoadTopButton: boolean = true;
  @State wallpaperScaleEnable: boolean = false;
  @State isFocusCancel: boolean = false;
  /**
   * 应用壁纸对应屏幕选择状态映射
   */
  private selectedInfos: Map<WallpaperQualifier, SelectedInfo> = new Map();
  private hasRectQualifiers: WallpaperQualifier[] = [];
  private resetClockEditTask: number = -1;
  @State refreshClockData: RefreshClockData = new RefreshClockData();
  @State refreshWallpaperBasicData: RefreshWallpaperBasicData = new RefreshWallpaperBasicData();
  @State isBack: boolean = false;
  private componentObserver: inspector.ComponentObserver | undefined;
  private rotationQualifier: WallpaperQualifier = this.currentQualifier;
  private getImageUrl: (qualifier: WallpaperQualifier) => string | undefined = () => {
    return this.params?.imageURL;
  };
  private getWallpaperImage: () => image.PixelMap | undefined = () => {
    return this.wallpaperPixelMap;
  };
  private getTabQualifier: () => WallpaperQualifier = () => {
    return this.tabQualifier;
  };
  private wallpaperContext: WallpaperContext =
    createWallpaperContext(this.getImageUrl, this.getWallpaperImage, this.getTabQualifier);
  private rotationProcessor: () => void = () => {
    let currentRotation: number = 0;
    try {
      currentRotation = display.getDefaultDisplaySync().rotation;
    } catch (e) {
      return;
    }
    if (this.preRotation !== currentRotation) {
      Log.info(TAG, `rotation change preRotation${this.preRotation},currentRotation:${currentRotation}`);
      clearTimeout(this.rotateEnableTimeId);
      this.preRotation = currentRotation;
    }
  };
  /**
   * 是否正在展示ErrorToast，true：正在展示，不需要重复展示
   */
  private isShowingErrorToast: boolean = false;
  /**
   * 应用壁纸预览框卡片选择回调，用于WallpaperEditor中响应回调
   * selectedInfo：当前卡片的选择信息（限定词、锁屏是否选中、桌面是否选中）
   */
  private selectedCallBack: Nullable<(selectedInfo: SelectedInfo) => void>;

  /**
   * 是否使用新材质
   */
  private isNewMaterialSupported: boolean = HdsMaterialManager.getInstance().isSupportHdsMaterial;

  /**
   * 壁纸选中回调,用于在"WallpaperEditor"中处理更换壁纸选中拦截逻辑,默认为空,当前只在三折叠MovingPhoto壁纸拦截混搭操作
   * param:选中壁纸参数
   * isClickOkCallback:更换壁纸或者取消回调
   */
  private cardSelectCallback: Nullable<(param: EnterWallpaperEditorParam,
    isClickOkCallback: (isClickOk: boolean) => void) => void>;

  private clockBorderPopupTipOnWillDismiss: (action: DismissPopupAction) => boolean = (action: DismissPopupAction) => {
    if (action.reason === DismissReason.PRESS_BACK) {
      this.buttonGroupLeftCallback();
    }
    action.dismiss();
    return true;
  }

  private getCamMoverImageRes(wallpaperPixalmap: PixelMap | undefined): Promise<CamMoverRes> {
    return CAMMOVER_SERVICE.getCamMoverImageRes(wallpaperPixalmap);
  }

  private usingCamMover(): boolean {
    return this.enableCamMover && this.showCMPreview;
  }

  private waitingCamMoverMesh(): boolean {
    return this.usingCamMover() && !this.cameraMoverSuccess;
  }

  private openCamMoverSheet() {
    this.cameraMoverLockSnapShot?.release();
    this.cameraMoverLockSnapShot = undefined;
    this.cameraMoverHomeSnapShot?.release();
    this.cameraMoverHomeSnapShot = undefined;
    let isFold = DeviceHelper.isFoldFolded();
    let isLand = DeviceHelper.isLandScape();
    this.getCamMoverImageRes(this.wallpaperPixelMap)
      .then(async (res) => {
        Log.info(TAG, 'getCamMoverImageRes done');
        // instrument ignore if
        if (!res.lock || !res.home) {
          Log.error(TAG, 'camera mover res is release, dont need to apply wallpaper');
        } else if (this.isPad) {
          this.camMoverRes = res;
          this.cameraMoverLockSnapShot = isLand ? res.lockLand : res.lock;
          this.cameraMoverHomeSnapShot = isLand ? res.homeLand : res.home;
        } else if (this.isBigFold) {
          this.camMoverRes = res;
          this.cameraMoverLockSnapShot = isFold ? res.lockFold : res.lock;
          this.cameraMoverHomeSnapShot = isFold ? res.homeFold : res.home;
        } else {
          this.camMoverRes = res;
          this.cameraMoverLockSnapShot = res.lock;
          this.cameraMoverHomeSnapShot = res.home;
        }
      })
      .catch((err: string) => {
        Log.error(TAG, `${err}`);
      });
  }

  private async openDialogController(): Promise<void> {
    await this.checkWatchStatus();
    this.customDialogComponentId = await DialogUtil.openDialog(this.getUIContext(), {
      builder: () => {
        this.applySheetBuilder();
      },
      autoCancel: true,
      alignment: DialogAlignment.Center,
      onDidDisappear: () => {
        this.isApplySheetShow = false;
      },
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
    });
  }

  private async checkWatchStatus(): Promise<DeviceImpl | undefined> {
    let device: DeviceImpl | undefined = await this.watchFaceHelper.getWatchDevice();
    // instrument ignore if
    if (device) {
      Log.info(TAG, 'has connect watch.');
      device.setInterfaceName(WearableAbility.name);
      this.isApplyWatch = true;
      this.isConnectWatch = true;
      return device;
    }
    this.isConnectWatch = false;
    return undefined;
  }

  // instrument ignore next
  private changeFontScale(): void {
    this.fontScale = 1.0; // Sceneboard锁屏未适配适老化，与锁屏保持一直按1.0显示
  }

  private watchSetQualifierOnly(): void {
    this.qualifierSetting = this.isSetTabQualifierOnly ? this.tabQualifier : undefined;
  }

  // 处理tab按钮的变化
  private tabChange(): void {
    this.setTabQualifier(this.tabQualifier);
    this.updateWallpaperScale(this.tabQualifier, this.currentQualifier);
    ClockParamAdapter.sizeControl(this.qualifierManager.getDeviceSize(this.tabQualifier),
      Math.max(this.physicalScale, SCALE_ORIGIN));
    let supportEdit: boolean = this.clockDataManager.getIsClockSupportEdit(this.currentQualifier, this.tabQualifier);
    // 小预览大时，关闭编辑白框
    this.supportEdit = (this.physicalScale >= SCALE_ORIGIN || supportEdit) ? true : false;
    Log.info(TAG, `tabChange supportEdit=${this.supportEdit}, physicalScale = ${this.physicalScale}`);
    let signString: string = this.clockUiSwitchSet.signString;
    let isSignVisible: boolean = this.clockUiSwitchSet.isSignVisible;
    this.formConfig = this.clockDataManager.getFormConfig(this.tabQualifier);
    Log.info(TAG, `tabChange tabQualifier = ${this.tabQualifier}, formConfig=${JSON.stringify(this.formConfig)}`);
    if (this.tabQualifier !== this.currentQualifier) {
    }
    emitter.emit(EventId.EDITOR_TAB_QUALIFIER_CHANGE);
  }

  private setTabQualifier(tabQualifier: WallpaperQualifier): void {
    this.qualifierManager.setTabQualifier(tabQualifier);
  }

  // 计算tab状态和物理状态之间的显示比例，tab切换或者物理切换时都要触发
  private updateWallpaperScale(tabQualifier: WallpaperQualifier, physicalQualifier: WallpaperQualifier): void {
    let widthScale: number = this.qualifierManager.getDeviceSize(physicalQualifier)[WIDTH_INDEX] /
    this.qualifierManager.getDeviceSize(tabQualifier)[WIDTH_INDEX];
    let heightScale: number = this.qualifierManager.getDeviceSize(physicalQualifier)[HEIGHT_INDEX] /
    this.qualifierManager.getDeviceSize(tabQualifier)[HEIGHT_INDEX];

    let minScale: number = Math.min(widthScale, heightScale);
    this.physicalScale = minScale;
    Log.info(TAG, `updateWallpaperScale physicalScale ${this.physicalScale}`);
  }

  private async onAccessModeChange(): Promise<void> {
    LayoutGridTool.setAccessibilityMode(this.isAccessibilityMode);
    if (!this.isAccessibilityMode) {
      this.setClockEditTimeOut();
      return;
    }
    Log.info(TAG, `onAccessModeChange supportEdit true`);
    this.supportEdit = true;
  }

  private readDesktopBlur(): void {
    // instrument ignore else
    if (!this.isAccessibilityMode) {
      return;
    }
    const blurState: Resource = this.isDesktopBlur ? $r('app.string.blurred') : $r('app.string.un_blurred');
    let accessText: string = accessHelper.appendAccessibilityText($r('app.string.homescreen'), blurState, true);
    if (this.isDesktopBlur) {
      const tipText: string = accessHelper.getStrByResource($r('app.string.blur_slider_read_notes'));
      accessText = `${accessText}, ${tipText}`;
    }
    accessHelper.doReadString(accessText);
  }

  private readUnlockBlur(): void {
    // instrument ignore else
    if (!this.isAccessibilityMode) {
      return;
    }
    let accessText = this.isLockscreenBlur ?
      $r('app.string.blurred') : $r('app.string.un_blurred');
    accessHelper.doReadString(accessHelper.appendAccessibilityText($r('app.string.lockscreen')
      , accessText, true));
  }

  private readShowDesktop(): void {
    // instrument ignore else
    if (this.isShowDesktop) {
      ComStUtil.setWallpaperExtentionShow(true); // 切到桌面则关闭锁屏popup
    }
    if (!this.isAccessibilityMode) {
      return;
    }
    let accessText = this.isShowDesktop ? $r('app.string.switched_desktop_preview')
      : $r('app.string.switched_lock_screen_preview');
    accessHelper.doRead(accessText);
  }

  private subscribeInfo?: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      'ThemeFinishLoading',
      'ts.event.theme.change',
    ],
    publisherBundleName: Constants.SCENE_BOARD_BUNDLE_NAME,
  };
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private mAlarmId: number = -1;
  private mClockEditAlarmId: number = -1;
  @State thumbnailPixelMap?: PixelMap = undefined;
  private navBackTimer: number = 0;

  private updateBlurRadius(): void {
    Log.info(TAG, `updateBlurRadius: ${this.blurRadius}`);
    this.baseWallpaperProp.blurRadius = this.blurRadius;
    this.unfoldedWallpaperProp.blurRadius = this.blurRadius;
    this.landWallpaperProp.blurRadius = this.blurRadius;
    this.unfolded2WallpaperProp.blurRadius = this.blurRadius;
    this.land2WallpaperProp.blurRadius = this.blurRadius;
  }

  private updateCameraMoverSnapshot() {
    this.isUnfold = !DeviceHelper.isFoldFolded();
    let deviceIsLand = DeviceHelper.isLandScape();
    this.isChange = !this.isChange;
    // instrument ignore else
    if (this.camMoverRes === undefined) {
      return;
    }
    if (this.isPad) {
      this.cameraMoverLockSnapShot = deviceIsLand ? this.camMoverRes.lockLand : this.camMoverRes.lock;
      this.cameraMoverHomeSnapShot = deviceIsLand ? this.camMoverRes.homeLand : this.camMoverRes.home;
    } else if (this.isBigFold) {
      this.cameraMoverLockSnapShot = !this.isUnfold ? this.camMoverRes.lockFold : this.camMoverRes.lock;
      this.cameraMoverHomeSnapShot = !this.isUnfold ? this.camMoverRes.homeFold : this.camMoverRes.home;
    } else {
      this.cameraMoverLockSnapShot = this.camMoverRes.lock;
      this.cameraMoverHomeSnapShot = this.camMoverRes.home;
    }
  }

  // 限定符更新时刷新界面
  private updateLayout = (): void => {
    try {
      this.updateCameraMoverSnapshot();
      this.isPortrait = display.getDefaultDisplaySync().orientation == display.Orientation.PORTRAIT ||
        display.getDefaultDisplaySync().orientation == display.Orientation.PORTRAIT_INVERTED;
      this.gridWidth = LayoutGridTool.getSingeGridSize(this.isPortrait, false);
      this.updateGridLayout();
      // instrument ignore else
      if (DeviceHelper.isFold()) {
        this.isFoldExpand = DeviceHelper.isFoldExpanded();
        this.isBigFoldExpand = DeviceHelper.isBigFoldExpanded();
      }
      this.isLand = DeviceHelper.isLandScape();
      // instrument ignore else
      if (this.isBigFold) {
        // instrument ignore else
        if (this.isFoldExpand) {
          this.applySheetWidth = ResourceManager.getInstance()
            .getNumberByResource($r('app.float.wallpapereditor_fold_preview_width'));
          this.applySheetMargin = 0;
        } else {
          this.applySheetWidth = '100%';
        }
      }
      this.tabQualifier = this.currentQualifier;
      Log.info(TAG, `updateLayout currentQualifier=${this.currentQualifier}`);
    } catch (e) {
      Log.error(TAG, 'do display action error');
    }
  };

  changeEdit() {
    this.navBackgroundColor = Color.Black;
    if (!this.isReportedChange) {
      this.isReportedChange = true;
      HiSysEventUtil.reportChangeAesthetic(this.markWallpaperEntrance());
    }
    this.isEdited = true;
  }

  private isEditWallpaperChange(): void {
    if (this.isEditWallpaper) {
      this.isHideTopButton = false;
      this.isHideBottomButton = false;
      this.resetClockWidgetDefault();
    }
  }

  private checkNeedReload(layoutOld: ClockLayout | number | undefined, layoutNew: ClockLayout | number | undefined,
    qualifier: WallpaperQualifier = WallpaperQualifier.BASE): boolean {
    // instrument ignore if
    if (!layoutOld) {
      Log.warn(TAG, `checkNeedReload layoutOld is undefined`);
      layoutOld = 0;
    }
    if (!layoutNew) {
      Log.warn(TAG, `checkNeedReload layoutNew is undefined`);
      return true;
    }
    Log.info(TAG, `checkNeedReload layoutOld = ${layoutOld}, layoutNew = ${layoutNew}`);
    let newLayout: CardLayout = LayoutGridTool.getCardPositionPattern(layoutNew);
    let needReload =
      LayoutGridTool.getCardPositionPattern(layoutOld) !== LayoutGridTool.getCardPositionPattern(layoutNew);
    if (needReload) {
      return needReload;
    }
    let formConfig: LockscreenFormConfig[] = this.clockDataManager.getFormConfig(qualifier);
    for (let i = 0; i < formConfig.length; i++) {
      if (newLayout === CardLayout.ONE_ROW && formConfig[i].positionY > POSITION_Y_MIN) {
        needReload = true;
        break;
      }
      if (newLayout === CardLayout.TWO_ROW &&
        (formConfig[i].positionX > POSITION_X_MAX || formConfig[i].positionX < POSITION_X_MIN)) {
        needReload = true;
        break;
      }
    }
    return needReload;
  }

  async loadPreviewsIfNecessaryEx(): Promise<void> {
    // instrument ignore if
    if (!this.isImageLoaded) {
      return Promise.reject();
    }

    let tasks: Promise<boolean>[] = [];

    for (let i = 0; i < this.allQualifiers.length; i++) {
      let qualifier: WallpaperQualifier = this.allQualifiers[i];
      let pixelMap: Nullable<image.PixelMap> = QualifierManager.getInstance().getWallpaperProp(qualifier)?.pixelMap;
      Log.error(TAG, `loadPreviewsIfNecessaryEx ${qualifier} pixelMap null:${pixelMap === undefined}`);
      tasks.push(this.qualifierManager.fillWallpapers(
        qualifier,
        this.aesManager.getDofImage(qualifier),
        this.isDesktopBlur,
        this.isLockscreenBlur,
        pixelMap));
    }

    Promise.allSettled(tasks).then((results) => {
      // instrument ignore if
      if (!this.isImageLoaded) {
        return Promise.reject();
      }
      let resultArr: string[] = results.map((value) => {
        return value.status;
      });
      Log.info(TAG, `fillWallpaper tasks done ${resultArr}`);
      return Promise.resolve();
    })
      .catch(() => {
        Log.error(TAG, `fillWallpaperSnapshots error`);
        this.qualifierManager.releaseAllSnapshots();
      });
    return;
  }

  async loadPreviewsIfNecessary(): Promise<void> {
    // instrument ignore if
    if (!this.isImageLoaded) {
      return Promise.reject();
    }
    // instrument ignore if
    if (!this.wallpaperPixelMap) {
      Log.error(TAG, 'wallpaper is release, dont need to apply wallpaper');
      return;
    }

    let tasks: Promise<boolean>[] = [];
    // instrument ignore if
    if (this.isSetTabQualifierOnly) { // 勾选 仅设置X屏壁纸，需要保存原有base目录下的原图
      await this.wallpaperFileManager.saveExistWallpapers(this.tabQualifier);
    }
    for (let i = 0; i < this.allQualifiers.length; i++) {
      let qualifier: WallpaperQualifier = this.allQualifiers[i];
      tasks.push(this.qualifierManager.fillWallpapers(
        qualifier,
        this.aesManager.getDofImage(qualifier),
        this.isDesktopBlur,
        this.isLockscreenBlur,
        this.wallpaperPixelMap));
    }

    Promise.allSettled(tasks).then((results) => {
      // instrument ignore if
      if (!this.wallpaperPixelMap || !this.isImageLoaded) {
        return Promise.reject();
      }
      let resultArr: string[] = results.map((value) => {
        return value.status;
      });
      Log.info(TAG, `fillWallpaper tasks done ${resultArr}`);
      return Promise.resolve();
    })
      .catch(() => {
        Log.error(TAG, `fillWallpaperSnapshots error`);
        this.qualifierManager.releaseAllSnapshots();
      });
    return;
  }

  private createWallpaperAttrByQualifier(qualifier: WallpaperQualifier): WallpaperAttr {
    if (qualifier === WallpaperQualifier.UNFOLDED) {
      return {
        originHeight: vp2px(this.unfoldedWallpaperProp.imageHeight),
        originWidth: vp2px(this.unfoldedWallpaperProp.imageWidth),
      };
    }
    if (qualifier === WallpaperQualifier.LAND || qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return {
        originHeight: vp2px(this.landWallpaperProp.imageHeight),
        originWidth: vp2px(this.landWallpaperProp.imageWidth),
      };
    }
    return {
      originHeight: vp2px(this.baseWallpaperProp.imageHeight),
      originWidth: vp2px(this.baseWallpaperProp.imageWidth),
    };
  }

  private createSingleThemeConfigParamArray(): SingleThemeConfigParams[] {
    let paramsArray: SingleThemeConfigParams[] = [];
    let validQualifiers: WallpaperQualifier[] =
      this.qualifierManager.getQualifiersToApply(this.isSetTabQualifierOnly, this.tabQualifier);
    for (const qualifier of validQualifiers) {
      const params: SingleThemeConfigParams = {
        qualifier: qualifier,
        lockScreenConfig: this.getLockConfigByQualifierWithCardIdCheck(qualifier),
        rect: this.qualifierManager.getDisplayRect(qualifier),
        wallpaperAttr: this.createWallpaperAttrByQualifier(qualifier),
        isDofDone: false,
        isDofShow: false,
      };
      paramsArray.push(params);
    }
    return paramsArray;
  }

  private async getImageSaliency(): Promise<ImageSaliency | undefined> {
    if (!this.isHomeScreenSelected) {
      return undefined;
    }
    // instrument ignore if
    if (this.params.imageSaliency) {
      return this.params.imageSaliency;
    }
    // instrument ignore else
    if (this.params.imageURL && this.params.imageURL.startsWith(Constants.MEDIA_PREFIX)) {
      return await WallpaperUtil.getPhotoSaliency(getContext(), this.params.imageURL);
    }
    Log.info(TAG, `getImageSaliency, no match, will return undefined`);
    return undefined;
  }

  private async loadCamMover(): Promise<Number> {
    let screenStatus: Number = CAMMOVER_SERVICE.getCurScreenStatus(this.isShowDesktop);
    let deviceType: Number = CAMMOVER_SERVICE.getCamMoverDeviceType();
    let isFolded: Boolean = DeviceHelper.isFoldFolded();
    CAMMOVER_SERVICE.setDeviceType(deviceType);
    let ret = CAMMOVER_SERVICE.setDeviceInfo(isFolded, screenStatus);
    Log.info(TAG,
      `Camera mover setDeviceInfo init, ret${ret}, type${deviceType}, desk=${this.isShowDesktop}, isFolded=${isFolded}`);
    ret = await CAMMOVER_SERVICE.initService(this.uiContext.resourceManager, this.filesDir) as Number;
    Log.info(TAG, `Camera mover init finish, ret${ret}`);
    return ret;
  }

  private async tryRunMesh(): Promise<Number> {
    let ret = await CAMMOVER_SERVICE.runMesh() as Number;
    Log.info(TAG, `tryRunMesh done ret:${ret}`);
    return ret;
  }

  private getRectUnionSet(rect0: AnyRect, rect1: AnyRect): AnyRect {
    let unionRectX: number = rect0.x < rect1.x ? rect0.x : rect1.x;
    let unionRectY: number = rect0.y < rect1.y ? rect0.y : rect1.y;
    let rect0MaxX: number = rect0.x + rect0.width;
    let rect0MaxY: number = rect0.y + rect0.height;
    let rect1MaxX: number = rect1.x + rect1.width;
    let rect1MaxY: number = rect1.y + rect1.height;
    let maxX: number = rect0MaxX > rect1MaxX ? rect0MaxX : rect1MaxX;
    let maxY: number = rect0MaxY > rect1MaxY ? rect0MaxY : rect1MaxY;

    let unionRectWidth: number = maxX - unionRectX;
    let unionRectHeight: number = maxY - unionRectY;
    return new AnyRect({
      x: unionRectX,
      y: unionRectY,
      width: unionRectWidth,
      height: unionRectHeight,
    });
  }

  private getSquaresRect(oriRect: AnyRect): AnyRect {
    let squareX: number = 0;
    let squareWidth: number = 0;
    let squareY: number = 0;
    let squareHeight: number = 0;
    let longSide: number = oriRect.height > oriRect.width ? oriRect.height : oriRect.width;
    let tmpX: number = oriRect.x - (longSide - oriRect.width) / 2;
    // instrument ignore if
    if (tmpX >= 0) {
      squareX = tmpX;
      squareWidth = longSide;
    } else {
      squareX = 0;
      squareWidth = longSide + tmpX;
    }
    let tmpY: number = oriRect.y - (longSide - oriRect.height) / 2;
    // instrument ignore else
    if (tmpY >= 0) {
      squareY = tmpY;
      squareHeight = longSide;
    } else {
      squareY = 0;
      squareHeight = longSide + tmpY;
    }
    Log.info(TAG,
      `oriRect==w=${squareWidth}, h=${squareHeight},x=${squareX}, y=${squareY},tmp=${tmpX},${tmpY}, ${longSide}`);
    return new AnyRect({
      x: squareX,
      y: squareY,
      width: squareWidth,
      height: squareHeight,
    });
  }

  private calcBigInputConfig(currentRect: AnyRect, hiddenRect: AnyRect, config: CamMoverConfig): void {
    let foldRect: AnyRect;
    let unFoldRect: AnyRect;
    // instrument ignore if
    if (!this.isUnfold) {
      foldRect = currentRect;
      unFoldRect = hiddenRect;
    } else {
      foldRect = hiddenRect;
      unFoldRect = currentRect;
    }

    let unFoldSquaresRect: AnyRect = this.getSquaresRect(unFoldRect);
    let unionRect: AnyRect = this.getRectUnionSet(foldRect, unFoldSquaresRect);
    // 相对大图坐标
    config.foldX = foldRect.x;
    config.foldY = foldRect.y;
    config.foldWidth = foldRect.width;
    config.foldHeight = foldRect.height;


    config.unfoldX = unFoldSquaresRect.x;
    config.unfoldY = unFoldSquaresRect.y;
    config.unfoldWidth = unFoldSquaresRect.width;
    config.unfoldHeight = unFoldSquaresRect.height;
    config.baseX = unionRect.x;
    config.baseY = unionRect.y;
    config.baseWidth = unionRect.width;
    config.baseHeight = unionRect.height;
  }

  private homeRectToLockRect(rect: AnyRect): AnyRect {
    // 获取的为桌面的x, y, 宽, 高, 需要转换成锁屏状态的
    let lockRectW: number = rect.width / Constants.LOCK_SCALE;
    let lockRectH: number = rect.height / Constants.LOCK_SCALE;
    const offsetX = (rect.width - lockRectW) / 2;
    const offsetY = (rect.height - lockRectH) / 2;
    let x: number = rect.x + offsetX;
    let y: number = rect.y + offsetY;
    return new AnyRect({
      x: x,
      y: y,
      width: lockRectW,
      height: lockRectH,
    });
  }

  private fillPadCamMoverConfig(lockImgRect: AnyRect, landRect: AnyRect, windowWidth: number,
    windowHeight: number, config: CamMoverConfig): void {
    if (this.isPad === false) {
      return;
    }
    config.portraitComp = new CamMoverCompositionConfig();
    config.portraitComp.rectX = lockImgRect.x;
    config.portraitComp.rectY = lockImgRect.y;
    config.portraitComp.rectW = lockImgRect.width;
    config.portraitComp.rectH = lockImgRect.height;
    let lockLandRect = this.homeRectToLockRect(landRect);
    config.landComp = new CamMoverCompositionConfig();
    config.landComp.rectX = lockLandRect.x;
    config.landComp.rectY = lockLandRect.y;
    config.landComp.rectW = lockLandRect.width;
    config.landComp.rectH = lockLandRect.height;
    Log.info(TAG,
      `==landLock: x=${lockLandRect.x},y=${lockLandRect.y},w=${lockLandRect.width},h=${lockLandRect.height}`);
    let unionRect: AnyRect = this.getRectUnionSet(lockImgRect, lockLandRect);
    config.baseX = unionRect.x;
    config.baseY = unionRect.y;
    config.baseWidth = unionRect.width;
    config.baseHeight = unionRect.height;
    if (this.currentQualifier == WallpaperQualifier.LAND) {
      config.landComp.windowWidth = windowWidth;
      config.landComp.windowHeight = windowHeight;
      config.portraitComp.windowWidth = windowHeight;
      config.portraitComp.windowHeight = windowWidth;
    } else {
      config.portraitComp.windowWidth = windowWidth;
      config.portraitComp.windowHeight = windowHeight;
      config.landComp.windowWidth = windowHeight;
      config.landComp.windowHeight = windowWidth;
    }
  }

  private fillCamMoverConfig(imgRect: AnyRect, hiddenRect: AnyRect, rotateRect: AnyRect, windowWidth: number,
    windowHeight: number, hiddenWindowWidth: number, hiddenWindowHeight: number): CamMoverConfig {
    let loadConfig: CamMoverConfig = new CamMoverConfig();
    // 获取的为桌面的x, y, 宽, 高, 需要转换成锁屏状态的
    let lockImgRect = this.homeRectToLockRect(imgRect);
    Log.info(TAG, `lockImgRect: x=${lockImgRect.x},y=${lockImgRect.y},w=${lockImgRect.width},h=${lockImgRect.height}`);
    loadConfig.baseX = lockImgRect.x;
    loadConfig.baseY = lockImgRect.y;
    loadConfig.baseWidth = lockImgRect.width;
    loadConfig.baseHeight = lockImgRect.height;
    Log.info(TAG,
      `===1.base: x=${loadConfig.baseX}, y=${loadConfig.baseY}, width=${loadConfig.baseWidth}, height=${loadConfig.baseHeight}`);
    loadConfig.windowWidth = windowWidth;
    loadConfig.windowHeight = windowHeight;
    loadConfig.expandRate = CAMERA_MOVER_EXPAND_RATE;
    this.fillPadCamMoverConfig(lockImgRect, rotateRect, windowWidth, windowHeight, loadConfig);
    // instrument ignore else
    if (this.isBigFold) {
      let lockHiddenRect = this.homeRectToLockRect(hiddenRect);
      Log.info(TAG,
        `lockHiddenRect: x=${lockHiddenRect.x}, y=${lockHiddenRect.y}, w=${lockHiddenRect.width}, h=${lockHiddenRect.height}`);
      this.calcBigInputConfig(lockImgRect, lockHiddenRect, loadConfig);
      // instrument ignore if
      if (!this.isUnfold) {
        loadConfig.foldWindowWidth = windowWidth;
        loadConfig.foldWindowHeight = windowHeight;
        loadConfig.unfoldWindowWidth = hiddenWindowWidth;
        loadConfig.unfoldWindowHeight = hiddenWindowHeight;
      } else {
        loadConfig.unfoldWindowWidth = windowWidth;
        loadConfig.unfoldWindowHeight = windowHeight;
        loadConfig.foldWindowWidth = hiddenWindowWidth;
        loadConfig.foldWindowHeight = hiddenWindowHeight;
      }
      loadConfig.isBigFold = true;
    }
    return loadConfig;
  }

  private fillOriginCamMoverConfig(config: CamMoverConfig): void {
    // instrument ignore if
    if (!this.isBigFold) {
      return;
    }
    let unfoldWinWidth = vp2px(this.qualifierManager.unfoldDisplayWidth);
    let unfoldWinHeight = vp2px(this.qualifierManager.unfoldDisplayHeight);
    let imgRect: AnyRect = WallpaperUtil.getDisplayInImageArea(this.unfoldedWallpaperProp,
      px2vp(unfoldWinHeight), px2vp(unfoldWinWidth));
    let imgRectLand: AnyRect = WallpaperUtil.getDisplayInImageArea(this.landWallpaperProp,
      px2vp(unfoldWinWidth), px2vp(unfoldWinHeight));

    config.originUnfoldX = imgRect.x;
    config.originUnfoldY = imgRect.y;
    config.originUnfoldWidth = imgRect.width;
    config.originUnfoldHeight = imgRect.height;

    config.originUnfoldLandX = imgRectLand.x;
    config.originUnfoldLandY = imgRectLand.y;
    config.originUnfoldLandWidth = imgRectLand.width;
    config.originUnfoldLandHeight = imgRectLand.height;
  }

  private copyAnyRect(src: AnyRect, dest: AnyRect) {
    dest.x = src.x;
    dest.y = src.y;
    dest.width = src.width;
    dest.height = src.height;
    dest.ratio = src.ratio;
  }

  private getPadLandRect(windWH: number[], imgRect: AnyRect): AnyRect {
    let landRect: AnyRect = new AnyRect({
      x: -1,
      y: -1,
      width: 0,
      height: 0,
    });
    // instrument ignore else
    if (!this.isPad) {
      return landRect;
    }
    // 当前屏为横屏状态时，获取的屏幕宽高为横屏状态下的宽高
    if (this.currentQualifier == WallpaperQualifier.LAND) {
      landRect = WallpaperUtil.getDisplayInImageArea(this.landWallpaperProp, px2vp(windWH[1]), px2vp(windWH[0]));
      Log.info(TAG, `landRect.x=${landRect.x}, y=${landRect.y}, w=${landRect.width}, h=${landRect.height}`);
      let portraitRect =
        WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp, px2vp(windWH[0]), px2vp(windWH[1]));
      this.copyAnyRect(portraitRect, imgRect);
    } else {
      landRect = WallpaperUtil.getDisplayInImageArea(this.landWallpaperProp, px2vp(windWH[0]), px2vp(windWH[1]));
      Log.info(TAG, `2.landRect.x=${landRect.x}, y=${landRect.y}, w=${landRect.width}, h=${landRect.height}`);
    }
    return landRect;
  }

  private fillBigFoldRectInfo(windWH: number[], hiddenWindWH: number[], imgRect: AnyRect, hiddenRect: AnyRect) {
    // instrument ignore if
    if (!this.isBigFold) {
      return;
    }
    // instrument ignore else
    if (this.currentQualifier == WallpaperQualifier.UNFOLDED) {
      let curRect = WallpaperUtil.getDisplayInImageArea(this.unfoldedWallpaperProp, px2vp(windWH[1]), px2vp(windWH[0]));
      Log.info(TAG, `1.curRect.x=${curRect.x},y=${curRect.y}, w=${curRect.width}, h=${curRect.height}`);
      this.copyAnyRect(curRect, imgRect);
      hiddenWindWH[0] = vp2px(this.qualifierManager.baseDisplayWidth);
      hiddenWindWH[1] = vp2px(this.qualifierManager.baseDisplayHeight);
      let foldRect = WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp,
        px2vp(hiddenWindWH[1]), px2vp(hiddenWindWH[0]));
      Log.info(TAG, `1.foldRect.x=${foldRect.x},y=${foldRect.y}, w=${foldRect.width}, h=${foldRect.height}`);
      this.copyAnyRect(foldRect, hiddenRect);
    } else if (this.currentQualifier == WallpaperQualifier.BASE) {
      hiddenWindWH[0] = vp2px(this.qualifierManager.unfoldDisplayWidth);
      hiddenWindWH[1] = vp2px(this.qualifierManager.unfoldDisplayHeight);
      let unfoldRect = WallpaperUtil.getDisplayInImageArea(this.unfoldedWallpaperProp,
        px2vp(hiddenWindWH[1]), px2vp(hiddenWindWH[0]));
      this.copyAnyRect(unfoldRect, hiddenRect);
    } else if (this.currentQualifier == WallpaperQualifier.UNFOLDED_LAND) {
      let curRect = WallpaperUtil.getDisplayInImageArea(this.landWallpaperProp, px2vp(windWH[1]), px2vp(windWH[0]));
      Log.info(TAG, `2.curRect.x=${curRect.x},y=${curRect.y}, w=${curRect.width}, h=${curRect.height}`);
      this.copyAnyRect(curRect, imgRect);
      Log.info(TAG, `rotate.x=${imgRect.x}, RotateRect.y=${imgRect.y}, w=${imgRect.width}, h=${imgRect.height}`);
      hiddenWindWH[0] = vp2px(this.qualifierManager.baseDisplayWidth);
      hiddenWindWH[1] = vp2px(this.qualifierManager.baseDisplayHeight);
      let foldRect = WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp,
        px2vp(hiddenWindWH[1]), px2vp(hiddenWindWH[0]));
      Log.info(TAG, `2.foldRect.x=${foldRect.x},y=${foldRect.y}, w=${foldRect.width}, h=${foldRect.height}`);
      this.copyAnyRect(foldRect, hiddenRect);
    }
  }

  private async tryDoCamMover(): Promise<Number> {
    return new Promise(async (resolve, reject) => {
      // instrument ignore if
      if (!this.usingCamMover()) {
        Log.warn(TAG, `tryDoCamMover will ignore because this.enableCamMover: ${this.enableCamMover}
                        && this.enableCamMover: ${this.showCMPreview}`);
        reject(-1);
        return;
      }
      let showSize: number[] = [0, 0];
      let hiddenSize: number[] = [0, 0];
      try {
        showSize[0] = display.getDefaultDisplaySync().width;
        showSize[1] = display.getDefaultDisplaySync().height;
      } catch (e) {
        Log.warn(TAG, `tryDoCamMover get display width or height failed: ${e?.code} - ${e?.message}`);
        reject(-1);
        return;
      }
      let imgRect: AnyRect =
        WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp, px2vp(showSize[1]), px2vp(showSize[0]));
      let hiddenRect: AnyRect = new AnyRect({
        x: -1,
        y: -1,
        width: 0,
        height: 0,
      });
      this.fillBigFoldRectInfo(showSize, hiddenSize, imgRect, hiddenRect);
      Log.info(TAG, `bigfold hidden.x=${hiddenRect.x},y=${hiddenRect.y},w=${hiddenRect.width},h=${hiddenRect.height}`);
      let landRect = this.getPadLandRect(showSize, imgRect);
      Log.info(TAG, `imgRect imgRect.x=${imgRect.x},y=${imgRect.y}, w=${imgRect.width}, h=${imgRect.height}`);
      Log.info(TAG, `==w=${showSize[0]}, h=${showSize[1]},hiddenW=${hiddenSize[0]}, h=${hiddenSize[1]}`);
      let loadConfig = this.fillCamMoverConfig(imgRect, hiddenRect, landRect, showSize[0], showSize[1],
        hiddenSize[0], hiddenSize[1]);
      this.fillOriginCamMoverConfig(loadConfig);
      let ret = await CAMMOVER_SERVICE.loadPixelMap(
        this.uiContext.resourceManager, this.wallpaperPixelMap!, this.filesDir, loadConfig) as number;
      // instrument ignore if
      if (ret !== 0) {
        Log.info(TAG, `loadPixelMap pixelmap failed`);
        reject(ret);
        return;
      }
      resolve(ret);
    });
  }

  private getColorType(color: string, brightness: number): ColorType {
    // instrument ignore else
    if (color.endsWith('FFFFFF')) {
      // instrument ignore else
      if (brightness >= 1) {
        return ColorType.LIGHT;
      }
      return ColorType.DARK;
    } else {
      return ColorType.MULTI_COLOR;
    }
  }

  // instrument ignore next
  private dataReceiveCallback(): (data: Object) => void {
    return (data) => {
      Object.keys(data).forEach(key => {
        if (key === Constants.BACK_EVENT) {
          this.doBack();
        }
        if (key === THEME_APP_MODE) {
          Log.info(TAG, 'receive windowStatusType from theme app');
          try {
            let appWindowStatusType: number = Number(Object.values(data).toString());
            this.appWindowStatusTypeChange(appWindowStatusType);
          } catch (err) {
            Log.error(TAG, `get appWindowStatusType error ${err?.code}`);
          }
        }
      });
    };
  };

  private appWindowStatusTypeChange(appType: number): void {
    Log.info(TAG, `appWindowStatusTypeChange ${appType}`);
    if (appType === WINDOW_FLOATING || appType === WINDOW_SPLIT_SCREEN) {
      this.showToast();
      setTimeout(() => {
        this.doSendData();
      }, QUIT_TIME);
    }
  }

  // instrument ignore next
  private doBack: () => Promise<void> =
    () => new Promise<void>(async () => {
      Log.info(TAG, 'doBack');
      if (this.isLoading) {
        return;
      }
      if (this.exitClockFontAigc()) {
        return;
      }
      if (this.isApplySheetShow) {
        this.isApplySheetShow = false;
        this.isHideBottomButton = false;
        DialogUtil.closeDialog(this.getUIContext(), this.customDialogComponentId);
        return;
      }
      if (this.clockWidgetEdit) {
        this.resetClockWidgetDefault();
        this.isHideBottomButton = false;
        return;
      }

      // 从桌面或者锁屏双指捏合进入
      if (this.isFromHomeOrLock) {
        Log.info(TAG, 'doBack , supportEdit is false');
        this.supportEdit = false; // 关闭锁屏时钟组件编辑状态 , 关闭时钟组件气泡提示
      }

      clearTimeout(this.navBackTimer);
      if (this.source === Constants.WALLPAPER_PICKER) {
        emitter.emit(EventId.BACK_TO_WALLPAPER_PICKER);
      }
      if (this.exitWallpaperEditor) {
        this.isExiting = true;
        this.navBackgroundColor = Color.Transparent;
        this.exitWallpaperEditor();
      } else {
        this.pageInfos.pop(NavigationUtil.session ? true : false);
      }
    });

  private exitClockFontAigc(): boolean {
    if (this.refreshClockData.showAiArtFontPage && this.adapter) {
      this.adapter.getEditHelper().getLayoutEditManger().handleBackProcess();
      Log.info(TAG, `do back for clock font aigc state`);
      return true;
    }
    return false;
  }

  /**
   * 用户编辑时钟时相关数据刷新。
   */
  async clockRefresh(property: string): Promise<void> {
    Log.info(TAG, `clockRefresh aestheticSuccess = ${this.isAesSuccess}, isReportedChange = ${this.isReportedChange},
    layout:${this.clockObject.layout}`);
    // instrument ignore if
    if (this.isAesSuccess && !this.isReportedChange) { // 打点刷新
      HiSysEventUtil.reportChangeAesthetic(this.markWallpaperEntrance());
      this.isReportedChange = true;
    }
    let qualifier: WallpaperQualifier = this.tabQualifier;
    // instrument ignore if
    if (property) {
      if (this.isAesLoaded && this.hasClockAction) {
        this.isEdited = true;
        this.syncEditStateToSl();
      }
      qualifier = this.clockDataManager.getQualifierByProperty(property);
      this.refreshClockCommon(qualifier); // 限定符联动属性刷新
    }
    this.notifyFontUpdateToDesktop(); // 桌面预览字体、颜色刷新
  }

  // 同步编辑状态到scb，使应用按钮状态同步
  private syncEditStateToSl(): void {
    if (this.isScreenLockKGSource()) {
      Log.info(TAG, 'syncEditStateToSl');
      NavigationUtil.session?.sendData({ 'isEdited': true });
    }
  }

  private async formRefresh(property: string): Promise<void> {
    if (!property) {
      Log.warn(TAG, `invalid formRefresh`);
      return;
    }
    Log.info(TAG, `formRefresh tabQualifier = ${this.tabQualifier}, formConfig=${JSON.stringify(this.formConfig)}`);
    this.clockDataManager.setFormConfig(this.tabQualifier, this.formConfig);
    this.clockDataManager.refreshFormCommon(this.tabQualifier, this.qualifierManager.allQualifiers, this.formConfig);
    if (this.isAesLoaded) {
      this.isEdited = true;
      this.syncEditStateToSl();
    }
  }

  /**
   * 通知桌面预览切换时钟，当前仅直板机生效
   */
  private notifyFontUpdateToDesktop(): void {
    if (this.clockObject.clockFontFamily !== this.originClockFont ||
      this.clockObject.clockStrokeColor !== this.originClockStrokeColor ||
      this.clockObject.colorStyle !== this.originClockStyle) {
      const fontFamily = this.clockObject.clockFontFamily;
      this.originClockFont = fontFamily;
      this.originClockStrokeColor = this.clockObject.clockStrokeColor;
      this.originClockStyle = this.clockObject.colorStyle;
      Log.info(TAG, `this.clockObject.clockFontFamily = ${fontFamily}`);
      // instrument ignore if
      if (this.desktopProxy) {
        const weatherData =
          ColorRenewalUtil.buildWeatherCardNotifyData(fontFamily, this.adapter, this.clockObject.clockStrokeColor);
        this.desktopProxy.send({ 'clockStyle': weatherData });
      } else {
        const desktopParams = AppStorage.get('desktopParam') as DesktopParam;
        // instrument ignore if
        if (desktopParams) {
          desktopParams.clockStyle =
            ColorRenewalUtil.buildWeatherCardNotifyData(fontFamily, this.adapter, this.clockObject.clockStrokeColor,
              this.clockObject.colorStyle);
          AppStorage.setOrCreate('desktopParam', desktopParams);
        }
      }
    }
  }
  /**
   * 刷新需要联动的属性，例如签名、横竖屏时钟样式（布局、颜色、字体）
   * @param qualifier 时钟数据被用户改变的限定符
   */
  private refreshClockCommon(qualifier: WallpaperQualifier): void {
    if (qualifier !== this.tabQualifier) {
      Log.info(TAG, `invalid refreshClockCommon`);
      return;
    }
    let clock: AnyClock = this.clockDataManager.getAnyClock(qualifier);

    // 将联动属性保存在ClockUiSwitchSet对象，原因：如果直接给AnyClock赋值会触发新一轮的刷新，造成死循环。
    this.clockUiSwitchSet.signString = clock.clockSignatureText;
    // instrument ignore if
    if (this.clockUiSwitchSet.signString && this.clockUiSwitchSet.signString.length > 0) {
      this.clockUiSwitchSet.isSignVisible = clock.isClockSignatureVisible;
    } else {
      this.clockUiSwitchSet.isSignVisible = false;
    }

    this.refreshClockLayoutForm(clock);

    // M态横竖屏、平板横竖屏时钟联动
    if (qualifier === WallpaperQualifier.UNFOLDED || qualifier === WallpaperQualifier.UNFOLDED_LAND || this.isPad) {
      // instrument ignore else
      Log.info(TAG, `Clock rotation related, qualifier = ${qualifier}`);
      this.clockUiSwitchSet.layoutRotation = clock.layout;
      this.clockUiSwitchSet.isChangeColor =  false;
      // instrument ignore if
      this.clockUiSwitchSet.colorRotation = clock.clockStrokeColor;
      this.clockUiSwitchSet.fontRotation = clock.clockFontFamily;
    } else { // 无需联动
      Log.info(TAG, `not rotation related`);
    }
    Log.info(TAG, `refreshClockCommon qualifier=${qualifier}, clockUiSwitchSet=${this.clockUiSwitchSet.toString()}`);
  }

  private refreshClockLayoutForm(currentClock: AnyClock): void {
    if (this.formConfig.length === 0) {
      // 艺术布局或者没有卡片不需要调整卡片布局
      return;
    }
    // 时钟布局发生变化的时候需要触发卡片位置调整
    if (currentClock.layout === this.clockUiSwitchSet.layoutRotation) {
      return;
    }
    this.clockDataManager.refreshFormCommon(this.tabQualifier, this.qualifierManager.allQualifiers, this.formConfig);
  }

  private updateGridLayout(): void {
    this.gridWidth = LayoutGridTool.getSingeGridSize(this.isPortrait, false);
  }

  private reportApplyOrCancel(isApplySuccess: boolean): void {
    let type: ApplyTypes;
    if (this.isLockScreenSelected && this.isHomeScreenSelected) {
      type = ApplyTypes.DESKTOP_AND_UNLOCK;
    } else if (this.isHomeScreenSelected) {
      type = ApplyTypes.DESKTOP;
    } else {
      type = ApplyTypes.UNLOCK;
    }
    this.wallpaperApplyType = type;
    let applyBlur: ApplyBlurType = ApplyBlurType.DESKTOP_UNLOCK;
    let blurRadius: number = this.blurRadius;
    // instrument ignore else
    if (this.isDesktopBlur && this.isLockscreenBlur) {
      applyBlur = ApplyBlurType.DESKTOP_UNLOCK;
    } else if (this.isDesktopBlur && !this.isLockscreenBlur) {
      applyBlur = ApplyBlurType.ONLY_DESKTOP;
    } else if (!this.isDesktopBlur && this.isLockscreenBlur) {
      applyBlur = ApplyBlurType.ONLY_UNLOCK;
    } else {
      applyBlur = ApplyBlurType.NONE;
      blurRadius = 0;
    }

    this.wallpaperChange.currRect = this.qualifierManager.getDisplayRect(this.currentQualifier);
    let wallpaperChange: WallpaperChangeInterface = {
      isVirtualEffect: applyBlur,
      blurRadius: this.blurRadius,
      isChangedPreview: this.isChangedPreview,
      moved: this.isMoved,
      zoom: this.isZoomed,
      type: type,
      isAesthetic: this.params.imageAesthetic ?? false,
      imageType: CacheManger.aestheticResult().getImageType(this.currentQualifier),
      isApplySuccess: isApplySuccess,
      isApplyCameraMover: this.showCMPreview,
      imageCategory: this.getImageCategory(),
      imageName: this.getImageName(),
      wallpaperEntrance: this.markWallpaperEntrance(),
      wallpaperType: HiSysEventUtil.getWallpaperEditFrom(this.params),
      coincidenceRatio: this.wallpaperChange.calcCoincidenceRatio(),
      isDof: false,
      aesDof: false,
    };
    if (this.clockObject.layout !== this.clockChange.originLayout) {
      this.clockChange.layoutChange = true;
    }
    if (this.clockObject.clockFontFamily !== this.clockChange.originFont) {
      this.clockChange.fontChange = true;
    }
    if (this.clockObject.clockStrokeColor !== this.clockChange.originColor) {
      this.clockChange.colorChange = true;
    }
    if (this.clockObject.x !== this.clockChange.originPositionX ||
      this.clockObject.y !== this.clockChange.originPositionY) {
      this.clockChange.dragChange = true;
    }
    HiSysEventUtil.reportApplyWallpaper(wallpaperChange, this.clockChange);
  }

  private getImageName(): string {
    if (!this.params.imageURL) {
      return '';
    }
    const wallpaperName: string[] = this.params.imageURL?.split('/') ?? [];
    if (wallpaperName.length === 0) {
      return '';
    }

    let wallPaperName = wallpaperName[wallpaperName.length - 1] ?? '';

    if (this.source === THEME_APP_BUNDLE) {
      Log.info(TAG, `wallpaper name: ${wallPaperName}`);
      return wallpaperName[wallpaperName.length - 1] ?? '';
    }
    for (const value of ThemeResourceController.themeResourceData.values()) {
      for (let path of value.wallpaper) {
        let wallpaperPath: string = ThemeResourceController.wallpaperPath + path;
        if (wallpaperPath === this.params.imageURL) {
          Log.info(TAG, `wallpaper name: ${wallPaperName}`);
          return wallPaperName;
        }
      }
    }
    return '';
  }

  /**
   * 获取壁纸类型，用于打点上报。
   *
   * @returns 当使用图库图片或在线图片时，返回''，否则返回植物，节日等预置壁纸类型。
   */
  private getImageCategory(): string {
    if (!this.params.imageURL || this.source === THEME_APP_BUNDLE) {
      return '';
    }
    const wallpaperName: string[] = this.params.imageURL?.split('/') ?? [];
    if (wallpaperName.length === 0) {
      return '';
    }
    for (const value of ThemeResourceController.themeResourceData.values()) {
      for (let path of value.wallpaper) {
        let wallpaperPath: string = ThemeResourceController.wallpaperPath + path;
        if (wallpaperPath === this.params.imageURL) {
          Log.info(TAG, `wallpaper category: ${value.seriesType}`);
          return value.seriesType;
        }
      }
    }
    return '';
  }

  private async processWantParams(): Promise<void> {
    this.processWallpaperPickerWantParams(); // 壁纸picker拉起
    await this.processWallpaperEditorWantParams(); // 外部直接拉起
  }

  private processWallpaperPickerWantParams(): void {
    const wallpaperPickerWant: WantParams[] = this.pageInfos.getParamByName(Constants.WALLPAPER_PICKER) as WantParams[];
    // instrument ignore else
    if (wallpaperPickerWant && wallpaperPickerWant.length > 0) {
      this.isFromHomeOrLock = !wallpaperPickerWant[0]?.isFull ?? false;
    }
    Log.info(TAG, `isFromHomeOrLock = ${this.isFromHomeOrLock}`);
  }

  private async processWallpaperEditorWantParams(): Promise<void> {
    let want: WantParams[] = this.pageInfos.getParamByName(Constants.WALLPAPER_EDITOR) as WantParams[];
    if (this.getWantSource(want) === SCB_SCREEN_LOCK) {
      this.source = SCB_SCREEN_LOCK; // 从大桌面锁屏拉起的场景，这里确定source后，及时赋值；避免闪白
      let session = want && want.length > 0 ? want[0]?.session : undefined;
      want = [];
      let param = await ScreenLockEditUtils.createWantParamsForSlCard(SCB_SCREEN_LOCK);
      param.session = session;
      want.push(param);
    } else if (NavigationUtil.isNavToWallpaperEditor(this.bundleSource)) {
      want = this.pageInfos.getParamByName(this.bundleSource) as WantParams[];
    }
    Log.info(TAG, `processWallpaperEditorWantParams want = ${want}, want.length = ${want.length}`)
    // instrument ignore else
    if (want && want.length > 0) {
      let param: WantParams = want[0];
      // instrument ignore if
      if (!param) {
        Log.error(TAG, 'param is null');
        return;
      }
      this.source = param.source ?? '';
      Log.info(TAG, `this.source = ${this.source}`);
      if (NavigationUtil.isNavToScreenlockEditor(this.source)) {
        this.bundleSource = this.source;
      }
      if (this.source === Constants.WALLPAPER_PICKER) {
        AppStorage.setOrCreate(AUTO_PICKER, true);
      }
      this.wallpaperExternalHelper.setExternalScene(this.source);
      this.imageId = param.imageIdForOnLine ?? '';
      this.imageOrigin = param.imageOrigin ?? '';
      // instrument ignore else
      this.params = new WallpaperEditorParams({
        imageURL: param.url ?? '',
        dofPath: '',
        imageRectDataArray: param.wallpaperRectDataArray ?? undefined,
        imageAesthetic: param.imageAesthetic ?? false,
        imageAestheticDof: false,
        imageAestheticResult: param.aestheticResult ?? undefined,
        imageSaliency: param.imageSaliency ?? undefined,
        lockScreenDataArray: param.lockScreenDataArray ?? undefined,
        needResetClock: param.needResetClock ?? false,
        shouldGetAestheticColor: param.shouldGetAestheticColor ?? true, // 默认都开启赋色
        shouldSaveHistoryWallpaperData: param.shouldSaveHistoryWallpaperData ?? false,
        wallpaperSourceType: param.wallpaperSourceType,
        imageId: param.imageIdForOnLine ?? '',
        imageOrigin: param.imageOrigin ?? '',
      });
      if (this.isScreenLockSCBSource()) {
        this.screenLockSpecialParams = new ScreenLockEditorSpecialParams(
          param.wallpaperRectDataArray,
          param.lockScreenWallpaperDatas,
          param.lockScreenWallpaperSourceTypes
        );
        this.updateCurrentParamsForSl();
      }
      this.isLoadTopButton = !this.isScreenLockKGSource();
      this.setEditorParamsBySource();
      // instrument ignore if
      if (!this.isFromHomeOrLock && param.session) {
        this.oldSession = NavigationUtil.session;
        if (this.isScreenLockCardSource()) {
          this.screenlockSession = param.session;
        } else {
          NavigationUtil.session = param.session;
        }
      }
      // instrument ignore if
      if (param.thumbnail) {
        this.createThumbnailPixelMap(param.thumbnail, param.wallpaperRectDataArray);
      }
    }
    this.processPresetRectData();
    this.processPresetLockScreenData();
  }

  private getWantSource(want: WantParams[]): string | undefined {
    if (!want || want.length === 0 || !want[0]) {
      Log.error(TAG, 'param is null');
      return undefined;
    }
    let param: WantParams = want[0];
    return param.source ?? ''
  }

  /**
   * 更新锁屏编辑的参数
   *
   * @param param
   */
  private updateCurrentParamsForSl() {
    if (this.screenLockSpecialParams?.lockScreenWallpaperDatas) {
      let lockScreenWallpaperData = this.screenLockSpecialParams?.lockScreenWallpaperDatas.get(this.currentQualifier);
      if (lockScreenWallpaperData) {
        this.params.imageURL = lockScreenWallpaperData.screenLockWallpaperUrl;
        this.params.dofPath = '';
        this.params.imageAestheticDof = false;
        Log.info(TAG, `currentQualifier = ${this.currentQualifier} imageAestheticDof = ${this.params.imageAestheticDof}`);
      }
    }
    if (this.screenLockSpecialParams?.lockScreenWallpaperSourceTypes) {
      this.params.wallpaperSourceType =
        this.screenLockSpecialParams?.lockScreenWallpaperSourceTypes.get(this.currentQualifier);
      Log.info(TAG, `currentQualifier = ${this.currentQualifier} wallpaperSourceType = ${this.params.wallpaperSourceType}`)
    }
  }

  /**
   * 判断来源是否要拉起锁屏编辑
   * @returns 是否为拉起锁屏编辑的来源
   */
  private isScreenLockSCBSource(): boolean {
    return this.isScreenLockKGSource() || this.isScreenLockCardSource();
  }

  /**
   * 特指来自大桌面（锁屏双指捏合或者长按时钟）拉起该页面的源
   * @returns 是否来自大桌面的源
   */
  private isScreenLockKGSource(): boolean {
    return this.source === SCB_SCREEN_LOCK;
  }

  private isScreenLockCardSource(): boolean {
    return this.source === Constants.SETTINGS_SCREENLOCK_CARD || NavigationUtil.isNavToScreenlockEditor(this.source);
  }

  private markWallpaperEntrance(): WallpaperEditEntrance {
    if (this.source === PHOTO_APP_BUNDLE) {
      return WallpaperEditEntrance.PHOTO_APP;
    } else if (this.source === AI_APP_BUNDLE) {
      return WallpaperEditEntrance.AI_APP;
    } else if (this.source === FILE_MANAGER_BUNDLE) {
      return WallpaperEditEntrance.FILEMANAGER_APP;
    } else if (this.source === THEME_APP_BUNDLE) {
      return WallpaperEditEntrance.THEME_APP;
    } else if (!this.isFromHomeOrLock && !this.isScreenLockSCBSource()) {
      return WallpaperEditEntrance.SETTING;
    } else if (screenLock.isLocked()) {
      return WallpaperEditEntrance.LOCK;
    } else if (this.source === Constants.SETTINGS_SCREENLOCK_CARD) {
      return WallpaperEditEntrance.SETTINGS_SCREENLOCK_CARD;
    } else {
      return WallpaperEditEntrance.DESKTOP;
    }
  }

  // 根据不同拉起来源设置不同的参数
  private setEditorParamsBySource(): void {
    // 20241122:从图库APP选择的图片也要视为历史壁纸
    // instrument ignore if
    if (this.source === PHOTO_APP_BUNDLE) {
      this.params.shouldSaveHistoryWallpaperData = true;
      this.params.wallpaperSourceType = WallpaperSourceType.PHOTO;
    }
    // instrument ignore if
    if (this.source === FILE_MANAGER_BUNDLE) {
      this.params.shouldSaveHistoryWallpaperData = true;
      this.params.wallpaperSourceType = WallpaperSourceType.FILE;
    }
    // instrument ignore if
    if (this.source === THEME_APP_BUNDLE) {
      // 20240920:主题APP要求重置时钟样式
      this.params.needResetClock = true;
    }
    // instrument ignore if
    if (this.source !== 'wallpaperPicker') {
      HiSysEventUtil.reportChooseWallpaper(HiSysEventUtil.getWallpaperEditFrom(this.params),
        this.markWallpaperEntrance());
    }
  }

  private processPresetRectData(): void {
    // instrument ignore else
    if (!this.params.imageRectDataArray) {
      Log.info(TAG, `imageRectDataArray is undefined`);
      return;
    }
    Log.info(TAG, `processPresetRectData, length: ${this.params.imageRectDataArray.length}`);
    for (let rectData of this.params.imageRectDataArray) {
      this.hasRectQualifiers.push(rectData.qualifier);
      let rect: AnyRect = this.qualifierManager.getAnyRect(rectData.qualifier);
      rect.x = rectData.rect.x;
      rect.y = rectData.rect.y;
      rect.width = rectData.rect.width;
      rect.height = rectData.rect.height;
      rect.ratio = rectData.rect.ratio;
    }
  }

  private processPresetLockScreenData(): void {
    Log.info(TAG, 'processPresetLockScreenData, start');
    // instrument ignore else
    if (!this.params.lockScreenDataArray) {
      return;
    }
    Log.info(TAG, `processPresetLockScreenData, length: ${this.params.lockScreenDataArray.length}`);
    for (let lockScreenData of this.params.lockScreenDataArray) {
      let lockScreen: LockscreenConfig = this.clockDataManager.getLockConfig(lockScreenData.qualifier);
      lockScreen.clock = lockScreenData.lockScreenConfig.clock;
      lockScreen.form = lockScreenData.lockScreenConfig.form ?? new LockscreenForm();
    }
  }

  initApplySheetParam(): void {
    // instrument ignore else
    if (DeviceHelper.isBigFoldExpanded()) {
      this.applySheetWidth = $r('app.float.applysheet_width');
      this.applySheetMargin = 0;
    } else if (this.isPad) {
      this.applySheetWidth = $r('app.float.applysheet_width');
      this.applySheetMargin = 0;
    } else if (DeviceHelper.isPhone()) {
      this.applySheetWidth = '100%';
    } else {
      this.applySheetWidth = $r('app.float.pc_applysheet_width');
    }
  }

  private async createThumbnailPixelMap(url: string, rectArray?: WallpaperRectData[]): Promise<void> {
    Log.info(TAG, `createThumbnailPixelMap WallpaperSourceType: ${this.params.wallpaperSourceType}`);
    try {
      if (rectArray) {
        this.thumbnailPixelMap =
          await PickerUtil.createCroppedPixelMapWithPath(url, PickerUtil.getRectByQualifierInArray(rectArray),
            this.params.imageURL);
      } else {
        this.thumbnailPixelMap = await PixelMapUtil.createPixelMapWithPath(url);
      }
      return;
    } catch (err) {
      Log.error(TAG, `err in createThumbnailPixelMap: ${err?.code}, ${err?.message}`);
      return;
    }
  }

  private setDesktopParams() {
    // 当前动效效果差，关闭桌面预览显示
    this.baseWallpaperProp.deviceWidth = this.qualifierManager.baseDisplayWidth;
    this.baseWallpaperProp.deviceHeight = this.qualifierManager.baseDisplayHeight;
  }

  private observeRootLayout(): void {
    const context: UIContext = this.getUIContext();
    const uiInspector: UIInspector = context.getUIInspector();
    this.componentObserver = uiInspector.createComponentObserver('wallpaperRoot');
    this.componentObserver.on('layout', () => {
      if (this.rotationQualifier !== this.currentQualifier) {
        Log.info(TAG, `wallpaper toot layout change:${this.currentQualifier}`);
        this.rotationQualifier = this.currentQualifier;
        clearTimeout(this.rotateEnableTimeId);
      }
    });
  }
  async aboutToAppear(): Promise<void> {
    Log.info(TAG, 'aboutToAppear');
    HiTraceUtil.start(WALLPAPER_EDITOR_ENTER);
    ComStUtil.setWallpaperExtentionShow(false);
    this.observeRootLayout();
    slEditorHelper.setAdapter(this.adapter);
    // 注册弹框消失事件
    this.adapter.getClockBorderPopupTipHelper().setOnWillDismiss(this.clockBorderPopupTipOnWillDismiss);
    emitter.on(EventId.SET_SCREENLOCK_SESSION, () => {
      this.setScreenlockSession();
    })
    BackEventController.get().clear();
    try {
      this.preRotation = display.getDefaultDisplaySync().rotation;
    } catch (e) {
      Log.info(TAG, `init rotation fail${e.message}`);
    }
    // 跳转入参解析
    await this.processInputParams();

    // 初始化锁屏编辑页面管理数据
    if (this.isScreenLockSCBSource()) {
      // 对于锁屏，刚进入不需要点阵动画，就直接设置点阵动画已播放完成
      this.isExpandHasFinish = true;
      await this.initLockSlEditorPageCtrlData();
    }

    // 设备形态参数初始化
    this.initDeviceParams();

    // 注册事件监听
    this.registerEvents();

    // 加载基础壁纸
    await this.loadWallpaperBasic();

    let qualifiers: WallpaperQualifier[] =
      this.allQualifiers.filter((item) => !this.hasRectQualifiers.includes(item));

    Log.info(TAG, `qualifiers length: ${qualifiers.length}`);

    // instrument ignore if
    if (this.isShowingErrorToast) { // 壁纸加载错误，3秒内自动退出壁纸编辑，不再执行后续逻辑
      Log.warn(TAG, 'Showing error toast');
      HiTraceUtil.end(WALLPAPER_EDITOR_ENTER);
      return;
    }

    if (!this.isScreenLockKGSource()) {
      UIExtensionPreloadUtil.preloadEditModeIconAbility(this.uiContext);
      // 手表初始化
      this.initWatch();
    }

    // 打点
    this.initSysEventData();
    HiTraceUtil.end(WALLPAPER_EDITOR_ENTER);
    try {
      display.on('change', this.rotationProcessor);
    } catch (error) {
      Log.error(TAG, `display error:${error.message}`);
    }
    if (this.isScreenLockKGSource()) {
      setTimeout(() => {
        try {
          NavigationUtil?.session?.sendData({ 'wallpaperEditorLoaded': true });
        } catch (error) {
          Log.error(TAG, `send data wallpaperEditorLoaded ${error.message}`)
        }
      }, LOAD_DELAY);
    }
  }

  private async initLockSlEditorPageCtrlData() {
    this.slEditorPageVm = new ScreenLockEditorPageVm();
    await this.slEditorPageVm.init(this.params.wallpaperSourceType);
    this.screenLockEditorPageCtlData = this.slEditorPageVm.getPageCtlData();
  }

  public navToClockTabCallback: () => void = () => {
    if (this.isNavToClockTabFinished) {
      return;
    }
    slStateHelper.getKeyguardEditState()?.enterEditState(EditState.CLOCK_EDIT);
    this.isNavToClockTabFinished = true;
  };

  private screenLockViewModelInit(): void {
    this.screenLockViewModel.onInit();
    this.screenLockViewModel.setRefreshData(this.refreshClockData);
    this.screenLockViewModel.setRefreshWallpaperBasicData(this.refreshWallpaperBasicData);
    this.screenLockViewModel.attachContext(this.wallpaperContext);
    this.screenLockViewModel.setAesManager(this.aesManager);
    this.screenLockViewModel.setNavToClockTabCallback(this.navToClockTabCallback);
    if (this.screenLockEditorPageCtlData) {
      this.screenLockEditorPageCtlData.isClockEditStateRegistered = true;
    }
  }

  private getQualifiers(qualifier: WallpaperQualifier): WallpaperQualifier[] {
    if (qualifier === WallpaperQualifier.UNFOLDED || qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return [WallpaperQualifier.UNFOLDED, WallpaperQualifier.UNFOLDED_LAND];
    }
    if (qualifier === WallpaperQualifier.UNFOLDED2 || qualifier === WallpaperQualifier.UNFOLDED2_LAND) {
      return [WallpaperQualifier.UNFOLDED2, WallpaperQualifier.UNFOLDED2_LAND];
    }
    return [qualifier];
  }

  private processHistoryLockScreenData(qualifiers: WallpaperQualifier[]): void {
    Log.info(TAG, 'processHistoryLockScreenData, start');
    // instrument ignore else
    if (!this.params.lockScreenDataArray) {
      return;
    }
    Log.info(TAG, `processHistoryLockScreenData, length: ${this.params.lockScreenDataArray.length}`);
    for (let lockScreenData of this.params.lockScreenDataArray) {
      if (!qualifiers.includes(lockScreenData.qualifier)) {
        continue;
      }
      let lockScreen: LockscreenConfig = this.clockDataManager.getLockConfig(lockScreenData.qualifier);
      lockScreen.clock = lockScreenData.lockScreenConfig.clock;
      lockScreen.form = lockScreenData.lockScreenConfig.form ?? new LockscreenForm();
    }
  }

  private processHistoryWallpaperData(qualifiers: WallpaperQualifier[]): WallpaperQualifier[] {
    let result: WallpaperQualifier[] = qualifiers;
    Log.info(TAG, `qualifiers: ${qualifiers.toString()},imageRectDataArray: ${this.params.imageRectDataArray?.length}`);
    if (!this.params.imageRectDataArray) {
      return result;
    }
    for (let rectData of this.params.imageRectDataArray) {
      if (!result.includes(rectData.qualifier)) {
        continue;
      }
      let rect: AnyRect = this.qualifierManager.getAnyRect(rectData.qualifier);
      rect.x = rectData.rect.x;
      rect.y = rectData.rect.y;
      rect.width = rectData.rect.width;
      rect.height = rectData.rect.height;
      rect.ratio = rectData.rect.ratio;
      result = result.filter(item => item !== rectData.qualifier);
    }
    return result;
  }

  private refreshWallpaperContents(qualifiers: WallpaperQualifier[]): void {
    this.updateGridLayout();

    // 保存初始时钟
    this.originClockFont = this.clockObject.clockFontFamily;
    emitter.on(EventId.REFRESH_DESKTOP, () => {
      this.isDesktopReady = true;
    });
    LayoutGridTool.setAccessibilityMode(this.isAccessibilityMode);
  }

  private initSysEventData(): void {
    this.clockChange = new ClockChange(this.clockObject.layout, this.clockObject.clockStrokeColor,
      this.clockObject.clockFontFamily, this.clockObject.x, this.clockObject.y);
    CacheManger.editSession().setOriginClockChange(this.allQualifiers, this.clockDataManager);
  }

  private initWatch(): void {
    ContextUtil.setUiContext(this.uiContext);
    deviceManager.init(ContextUtil.getUiContext());
  }

  private async loadWallpaperBasic(): Promise<void> {
    Log.info(TAG, `loadWallpaperBasic start, imageUrl = ${this.params.imageURL}`);
    // instrument ignore if
    if (!this.params.imageURL) {
      Log.error(TAG, `imageUrl invalid`);
      return;
    }

    // 加载缩略图
    if (!this.isThumbnailLoaded) {
      WallpaperUtil.getPhotoThumbnail(getContext(), this.params.imageURL, this.source === THEME_APP_BUNDLE)
        .then((pixelMap: PixelMap) => {
          this.wallpaperThumbnailPixel = pixelMap;
          this.isThumbnailLoaded = true;
          Log.info(TAG, `thumbnailLoaded done`);
        })
        .catch((err: string) => {
          Log.error(TAG, `getPhotoThumbnail err: ${err}`);
        });
    }
    let options: IPixelMapReadingOptions = {
      maximumWidth: MAX_WIDTH,
      isSandboxUri: this.wallpaperExternalHelper.isSandboxScene(),
      allocatorType: image.AllocatorType.DMA,
      wideGamutSdr: DeviceHelper.isSgu() ? true : false,
    };
    // 加载原图
    await PixelMapUtil.createPixelMapWithPath(this.params.imageURL, options)
      .then(async (pixelMap: PixelMap | undefined) => { // 如果动态壁纸稳帧成功会取代这个位图
        // instrument ignore if
        if (!pixelMap) {
          this.showErrorToastAndBack();
          return;
        }
        HiSysEventUtil.reportWallpaperEditorImageGet(true, this.markWallpaperEntrance());
        await this.initWallpaperPixelMap(pixelMap);
        await this.createRgbaPixelMap(pixelMap);
        this.wallpaperLoaded = true;
      })
      .catch((err: string) => {
        Log.error(TAG, `createPixelMapWithPath err=${err}`);
      });

    Log.info(TAG, 'loadWallpaperBasic done');

  }

  private async createRgbaPixelMap(pixelMap: image.PixelMap): Promise<void> {
    const imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
    if (imageInfo.pixelFormat === image.PixelMapFormat.RGBA_8888) {
      this.aesManager.setRgbaPixelMap(pixelMap);
      this.rgbaPixelMap = pixelMap;
      return;
    }
    let options: IPixelMapReadingOptions = {
      maximumWidth: MAX_WIDTH,
      isSandboxUri: this.wallpaperExternalHelper.isSandboxScene(),
      allocatorType: image.AllocatorType.DMA,
    };
    const wallpaperRgba: image.PixelMap | undefined =
      await PixelMapUtil.createPixelMapWithPath(this.params.imageURL, options);
    if (wallpaperRgba) {
      this.aesManager.setRgbaPixelMap(wallpaperRgba);
      this.rgbaPixelMap = wallpaperRgba;
    }
  }

  private async initWallpaperPixelMap(pixelMap: PixelMap): Promise<void> {
    await this.wallpaperPixelMap?.release();
    this.wallpaperPixelMap = pixelMap;
    this.qualifierManager.baseWallpaperProp.pixelMap = pixelMap;
    // instrument ignore if
    if (this.isPad) {
      this.qualifierManager.landWallpaperProp.pixelMap = pixelMap;
    }
    Log.info(TAG, `initWallpaperPixelMaps success`);
  }

  private async loadWallpaperFeatures(qualifiers?: WallpaperQualifier[]): Promise<void> {
    // instrument ignore if
    if (!this.params.imageURL) {
      Log.error(TAG, `loadWallpaperFeatures imageURL invalid`);
      return;
    }
    // 放在美学调用完之后注册锁屏组件接口，防止后面接口等待，锁屏组件已经展示点击时候没有注册
    this.screenLockViewModelInit();
    if (!this.isScreenLockKGSource()) {
      await this.initCamMover();
    }
  }

  private async initCamMover(): Promise<void> {
    await this.getPixelMapAndDoCamMover();
  }

  private registerEvents(): void {
    this.initSubscriber();
    this.changeWindowMode(true);
    NavigationUtil.session?.setReceiveDataCallback((data) => {
      Object.keys(data).forEach(key => {
        if (key === Constants.BACK_EVENT) {
          this.doBack();
        }
        if (key === THEME_APP_MODE) {
          Log.info(TAG, 'receive windowStatusType from theme app');
          try {
            let appWindowStatusType: number = Number(Object.values(data).toString());
            this.appWindowStatusTypeChange(appWindowStatusType);
          } catch (err) {
            Log.error(TAG, `get appWindowStatusType error ${err?.code}`);
          }
        }
        if (key === SHOW_EDITOR_TOP_BUTTON) {
          this.isLoadTopButton = data[SHOW_EDITOR_TOP_BUTTON] as boolean;
          if (!this.isLoadTopButton) {
            this.resetClockWidgetDefault();
          }
          Log.info(TAG, `receive msg from scb: ${this.isLoadTopButton}`);
          return;
        }
        if (key === WALLPAPER_SCALE_ENABLE) {
          this.wallpaperScaleEnable = data[WALLPAPER_SCALE_ENABLE] as boolean;
          Log.info(TAG, `receive wallpaperScaleEnable msg from scb: ${this.wallpaperScaleEnable}`);
          return;
        }
      });
    });
  }

  private initDeviceParams(): void {
    this.initApplySheetParam();
    this.setDesktopParams();
    this.initQualifiers();
  }

  private async processInputParams(): Promise<void> {
    WallpaperUtil.wallpaperEditorCount++;
    this.isFromBindSheet = this.exitWallpaperEditor !== undefined;
    if (this.isFromBindSheet) {
      this.navBackgroundColor = Color.Transparent;
      emitter.on(EventId.WALLPAPER_PICKER_SHARE_TRANSITION_FINISH, () => {
        if (this.originPixelMapReady) {
          this.navBackgroundColor = Color.Black;
        }
      });
    } else {
      // 把navigation背景色改为系统背景色，优化设置壁纸库到壁纸编辑转场闪黑体验
      this.navBackgroundColor = $r('sys.color.background_secondary');
    }
    await this.processWantParams();
  }

  @Builder
  desktopContent() {
    UIExtensionComponent(
      {
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'EditModeIconAbilityPhone',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': Constants.DESKTOP_PREVIEW,
          'desktopParam': AppStorage.get<Object>('desktopParam'),
        },
      },
    )
      .id('desktopPreview')
      .size({ width: '100%', height: '100%' })
      .focusable(false)
      .visibility(this.isShowDesktop ? Visibility.Visible : Visibility.None)
      .hitTestBehavior(this.isShowDesktop ? HitTestMode.Transparent : HitTestMode.Block)
      .transition(AnimationUtil.getClockInAndOutOpacityEffect())
      .onRemoteReady((proxy: UIExtensionProxy) => {
        Log.info(TAG, 'EditModeIconAbilityPhone onRemoteReady');
        this.desktopProxy = proxy;
        const weatherData = ColorRenewalUtil.buildWeatherCardNotifyData(this.clockObject.clockFontFamily,
          this.adapter, this.clockObject.clockStrokeColor, this.clockObject.colorStyle);
        this.desktopProxy?.send({ 'clockStyle': weatherData });
      })
      .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT);
  }

  private doCamMoverByEntrance(imageURL: string | undefined): boolean {
    // instrument ignore if
    if (!imageURL) {
      return false;
    }
    let deviceType = DeviceHelper.getFoldProductType();
    let sourceType = this.params.wallpaperSourceType;
    let source = this.source;
    Log.info(TAG, `doCamMoverByEntrance deviceType: ${deviceType}`);
    Log.info(TAG, `doCamMoverByEntrance sourceType: ${sourceType}`);
    Log.info(TAG, `doCamMoverByEntrance source: ${source}`);
    // 不是指定手机型号拒识
    // instrument ignore if
    if ((deviceType > 2 && deviceType !== 4) || deviceType < 0) {
      return false;
    }
    // CAMMOVER 电影运镜; PHOTO 图库入口; RECOMMEND 推荐壁纸; HISTORY 我的壁纸(历史); THEME 我的壁纸(当前壁纸)
    // instrument ignore if
    if (sourceType != 8 && sourceType != 5 && sourceType != 4 && sourceType != 3 && sourceType != 1 &&
      sourceType != 2 && sourceType != 6 &&
      !this.wallpaperExternalHelper.isNeedCamMover(this.source) &&
      source !== 'wallpaperPicker') {
      return false;
    }

    // instrument ignore if
    if (!DeviceHelper.isSupportCamMover()) {
      Log.error(TAG, `doCamMoverByEntrance rejected`);
      return false;
    }
    return true;
  }

  private async getPixelMapAndDoCamMover(imageURL: string | undefined = this.params.imageURL) {
    Log.info(TAG, 'start to getPixelMapAndDoCamMover');
    try {
      HiTraceUtil.start(WALLPAPER_EDITOR_CAMMOVER_INIT);
      // instrument ignore if
      if (!this.doCamMoverByEntrance(imageURL)) {
        Log.error(TAG, 'CamMover reject by entrance.');
        return;
      }
      const ret = await this.loadCamMover();
      // instrument ignore if
      if (ret !== 0) {
        Log.error(TAG, 'CamMover init failed, will not enable CamMover');
        HiTraceUtil.end(WALLPAPER_EDITOR_CAMMOVER_INIT);
        return;
      }
      Log.info(TAG, `Start to get pixelMap, imageUrl = ${imageURL}`);
      // instrument ignore if
      if (!imageURL) {
        Log.error(TAG, `imageUrl is undefined`);
        HiTraceUtil.end(WALLPAPER_EDITOR_CAMMOVER_INIT);
        return;
      }
      const shouldNotReject = await CAMMOVER_SERVICE.updateDbAndDoReject(getContext(), imageURL,
        this.wallpaperExternalHelper.isSandboxScene());
      // instrument ignore if
      const imageInfo: image.ImageInfo | undefined = await this.wallpaperPixelMap?.getImageInfoSync();
      Log.info(TAG, `check cam mover wallpaper format:${imageInfo?.pixelFormat}`);
      if (shouldNotReject && imageInfo?.pixelFormat === image.PixelMapFormat.RGBA_8888) {
        this.enableCamMover = true;
        this.showCamMoverButton = true;
        Log.info(TAG, 'CamMover is enabled');
      } else {
        Log.info(TAG, 'CamMover is disabled because of reject');
      }
      HiTraceUtil.end(WALLPAPER_EDITOR_CAMMOVER_INIT);
    } catch (error) {
      Log.error(TAG, `Error in getPixelMapAndDoCamMover: ${error}`);
    } finally {
      HiTraceUtil.end(WALLPAPER_EDITOR_CAMMOVER_INIT);
    }
  }

  /**
   * 壁纸编辑界面显示区域发生变化 , 判断当前是否处于小窗模式 , 小窗模式退出壁纸编辑页面
   */
  private async exitInSmallWindow(): Promise<void> {
    // instrument ignore if
    let isInSmallWindow: boolean =
      SmallWindowHelper.checkSmallWindow() &&
        !(await ThemeUtils.isAllowEnterFullScreenEditor() && this.checkIsAllowEnterFullScreenEditor);
    Log.info(TAG, `isInSmallWindow = ${isInSmallWindow} in exitInSmallWindow`);
    if (isInSmallWindow && !this.isBack) {
      this.showToast();
    }
    if (this.hasReturn) {
      Log.info(TAG, 'has return in exitInSmallWindow');
      return;
    }
    // instrument ignore if
    if (isInSmallWindow) { // 小窗模式退出壁纸编辑页面
      AppStorage.setOrCreate(AUTO_PICKER, false); // 不需要弹出图库Picker
      this.hasReturn = true;
      NavigationUtil.doSetSystemBarColor('reset');
      setTimeout(() => {
        this.changeWindowMode(false);
        if (this.wallpaperExternalHelper.isThemeAppScene()) {
          Log.info(TAG, 'setting ThemeApp scene, should send back.');
          this.doSendData();
          return;
        }
        if (DeviceHelper.isSettingSplitProduct()) {
          this.doSendData();
        } else {
          this.pageInfos.pop();
        }
      }, QUIT_TIME);
    }
  }

  private syncRotateClock(): void {
    const currentQualifier: WallpaperQualifier = this.qualifierManager.currentQualifier;
    const oldLayOut: ClockLayout = this.clockDataManager.getAnyClock(currentQualifier).layout;
    this.clockDataManager.applyClockCommon(); // 时钟样式联动
    const newLayOut: ClockLayout = this.clockDataManager.getAnyClock(currentQualifier).layout;
    Log.info(TAG, `syncRotateClock oldLayOut:${oldLayOut} newLayOut:${newLayOut}`);
  }

  private initQualifiers(qualifier?: WallpaperQualifier): void {
    if (!qualifier) {
      this.qualifierManager.releaseAllSnapshots();
    }
    this.isUnfold = !DeviceHelper.isFoldFolded();
    this.currentQualifier = this.qualifierManager.currentQualifier;
    this.tabQualifier = this.currentQualifier;
    this.setTabQualifier(this.tabQualifier);

    // 创建各限定符的WallpaperWriter对象
    this.allQualifiers.forEach((qualifier) => {
      this.qualifierManager.setWallpaperWriter(qualifier, this.params.imageURL ?? '');
    });

    // 物理限定符刷新回调
    this.qualifierManager.registerCurrentQualifierCallback(TAG, () => {
      this.syncRotateClock();
      let oldLayout: number = this.clockDataManager.getAnyClock(this.currentQualifier).layout;
      this.currentQualifier = this.qualifierManager.currentQualifier;
      this.clockDataManager.setFormReloadToQualifier(this.currentQualifier, // 对比服务卡片变化，判断是否需要reload
        this.checkNeedReload(oldLayout, this.clockDataManager.getAnyClock(this.currentQualifier).layout));
      this.updateLayout(); // 更新tabQualifier及其他属性
      this.updateWallpaperScale(this.tabQualifier, this.currentQualifier); // tabQualifier可能不更新，需要重新计算壁纸显示
      ClockParamAdapter.sizeControl(this.qualifierManager.getDeviceSize(this.tabQualifier),
        Math.max(this.physicalScale, SCALE_ORIGIN)); // tabQualifier可能不更新，需要重新计算时钟显示
      Log.info(TAG, `currentQualifierCallback, currentQualifier=${this.currentQualifier}`);
      if (this.clockLayoutMap.hasKey(this.currentQualifier)) {
        ClockArtStyleHelper.updateMirror(this.adapter, this.clockLayoutMap.get(this.currentQualifier));
      }
    });
    Log.info(TAG, `initQualifiers finish current=${this.currentQualifier}, allQualifiers=${this.allQualifiers}`);
  }

  private async showToast(): Promise<void> {
    Log.info(TAG, `showToast begin`);
    SmallWindowHelper.showWallpaperToast(this.getUIContext(),
      $r('app.string.wallpaper_cannot_be_edited_in_a_small_window'));
  }

  /**
   * 用于在不支持保存壁纸时的监听ts.event.theme.change
   */
  private handleThemeChange(): void {
    // 如果壁纸可编辑，直接监听ThemeFinishLoading
    if (!this.isScreenLockSCBSource()) {
      return;
    }
    if (this.screenLockEditorPageCtlData?.isWallpaperEditable) {
      return;
    }
    Log.info(TAG, `handleThemeChange`);
    // 由于监听来了后，外部界面其实还没刷新完成，由于没有额外监听，只能使用定时退出，保证退出后，外部界面已经刷新完成
    setTimeout(() => {
      this.loadingController?.close();
      if (this.isScreenLockKGSource()) {
        this.isInProgress = true;
        this.isLoading = false;
        this.applyThemeBack();
      } else {
        this.backToPickerOrApp();
      }
    }, SCREENLOCKEDIT_QUIT_TIME);
  }

  private initSubscriber(): void {
    try {
      commonEventManager.createSubscriber(this.subscribeInfo,
        (err: base.BusinessError, data: commonEventManager.CommonEventSubscriber) => {
          if (err) {
            Log.error(TAG, `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
            return;
          }
          this.subscriber = data;

          if (!this.subscriber) {
            Log.error(TAG, 'Failed to subscribe to theme active event - subscriber is undefined.');
            return;
          }

          Log.info(TAG, 'Successfully subscribed theme activate event.');
          try {
            commonEventManager.subscribe(this.subscriber,
              (err: base.BusinessError, eventData: commonEventManager.CommonEventData) => {
                if (eventData?.event === 'ts.event.theme.change') {
                  this.handleThemeChange();
                  return;
                }
                Log.info(TAG, 'receive commonEventManager');
                // 退出壁纸编辑
                if (this.mAlarmId !== -1) {
                  clearTimeout(this.mAlarmId);
                  this.mAlarmId = -1;
                }
                if (this.isLoading) {
                  Log.info(TAG, 'receive commonEventManager, need do animation');
                  this.isInProgress = true;
                  this.isLoading = false;
                  this.loadingController?.close();
                  this.applyThemeBack();
                }
              });
          } catch (e) {
            Log.error(TAG, 'commonEventManager subscribe error ');
          }
        });
    } catch (e) {
      Log.error(TAG, 'commonEventManager createSubscriber error ');
    }
  }

  private resetCamMoverSource() {
    if (this.cameraMoverLockSnapShot) {
      this.cameraMoverLockSnapShot?.release();
      this.cameraMoverLockSnapShot = undefined;
    }
    if (this.cameraMoverHomeSnapShot) {
      this.cameraMoverHomeSnapShot?.release();
      this.cameraMoverHomeSnapShot = undefined;
    }
    if (this.camMoverRes) {
      this.camMoverRes.lock && this.camMoverRes.lock.release();
      this.camMoverRes.home && this.camMoverRes.home.release();
      this.camMoverRes.aod && this.camMoverRes.aod.release();
      this.camMoverRes.lockFold && this.camMoverRes.lockFold.release();
      this.camMoverRes.homeFold && this.camMoverRes.homeFold.release();
      this.camMoverRes.aodFold && this.camMoverRes.aodFold.release();
      this.camMoverRes.lockLand && this.camMoverRes.lockLand.release();
      this.camMoverRes.homeLand && this.camMoverRes.homeLand.release();
      this.camMoverRes.aodLand && this.camMoverRes.aodLand.release();
    }
    CAMMOVER_SERVICE.unInitService();
  }

  aboutToDisappear() {
    Log.info(TAG, `aboutToDisappear, count: ${WallpaperUtil.wallpaperEditorCount}`);
    this.componentObserver?.off('layout');
    if (!this.isBack) {
      ThemeUtils.isAllowEnterFullScreenEditor().then((isAllowEnterFullScreenEditor: boolean) => {
        if (isAllowEnterFullScreenEditor) {
          ThemeUtils.exitFullScreenEditor([NavigationUtil.session, this.oldSession]);
          ThemeUtils.waitEnterFullScreenEditor(false);
          this.oldSession = undefined;
        }
      });
    }
    emitter.off(EventId.SET_SCREENLOCK_SESSION);
    emitter.off(EventId.WINDOW_SIZE_CHANGE);
    this.screenLockViewModel.onDestroy();
    ClockParamAdapter.turnOffSizeControl();
    this.isImageLoaded = false;
    clearTimeout(this.clearSetTimeout);
    // instrument ignore if
    if (this.thumbnailPixelMap) {
      this.thumbnailPixelMap.release();
      this.thumbnailPixelMap = undefined;
    }

    this.resetCamMoverSource();
    // instrument ignore else
    if (this.wallpaperThumbnailPixel) {
      this.wallpaperThumbnailPixel.release();
      this.wallpaperThumbnailPixel = undefined;
    }
    this.aesManager.clear();
    CacheManger.clear();
    this.clockDataManager.clear();
    this.releaseQualifiers();
    if (this.mAlarmId !== -1) {
      clearTimeout(this.mAlarmId);
      this.mAlarmId = -1;
    }
    try {
      commonEventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    } catch (e) {
      Log.error(TAG, 'commonEventManager unsubscribe error');
    }
    emitter.off(EventId.REFRESH_DESKTOP);
    if (this.isFromBindSheet) {
      emitter.off(EventId.WALLPAPER_PICKER_SHARE_TRANSITION_FINISH);
    }
    DesktopPreviewColorHelper.hasCalc = false;
    DesktopPreviewColorHelper.isFirstOn = false;
    DesktopPreviewColorHelper.preference?.off('multiProcessChange');
    // instrument ignore else
    if (!this.isFromHomeOrLock) {
      AppStorage.delete('desktopParam');
    }
    WallpaperUtil.wallpaperEditorCount--;
    this.wallpaperDisplaySync.stop();
    this.wallpaperFileManager.clearCachedDirs();
    ClockParamAdapter.destroy();
    this.hasRectQualifiers = [];
    try {
      display.off('change', this.rotationProcessor);
    } catch (error) {
      Log.error(TAG, `off change:${error.message}`);
    }
    this.checkIsAllowEnterFullScreenEditor = true;
    this.adapter.getClockWidgetModel().getRenewalColorStyleManager().destroy();
  }

  // 释放限定符相关资源
  private releaseQualifiers(): void {
    this.qualifierManager.releaseAllSnapshots();
    // instrument ignore else
    if (WallpaperUtil.wallpaperEditorCount === 1) {
      this.qualifierManager.clear();
    } else {
      Log.warn(TAG, `exist multiple WallpaperEditor instance, skip resetAllWallpaperProp`);
    }
    this.qualifierManager.unRegisterCurrentQualifierCallback(TAG);
  }

  // instrument ignore next
  private showErrorToastAndBack(): void {
    this.isShowingErrorToast = true;
    //在从文件管理器进入壁纸编辑的场景，如果选择不可用的图片作为壁纸，需要通过文件管理器显示报错信息。
    NavigationUtil.session?.sendData({'imageError': true});
    this.promptAction.showToast({
      message: $r('app.string.image_decoding_failure'),
      duration: IMAGE_DECODING_FAILED_DURATION,
    });
    HiSysEventUtil.reportWallpaperEditorImageGet(false, this.markWallpaperEntrance());
    this.navBackTimer = setTimeout(() => {
      if (this.pageInfos.getAllPathName().includes(Constants.WALLPAPER_EDITOR)) {
        // 保证当前在壁纸编辑内
        this.backToPickerOrApp();
      }
    }, IMAGE_DECODING_FAILED_DURATION);
  }

  // instrument ignore next
  private backToPickerOrApp() {
    this.needFreeze = true;
    this.hasReturn = true;
    NavigationUtil.doSetSystemBarColor('reset');
    if (this.source === Constants.WALLPAPER_PICKER) {
      emitter.emit(EventId.BACK_TO_WALLPAPER_PICKER);
    }
    Log.info(TAG, 'backToPickerOrApp start to back');
    if (NavigationUtil.session) {
      if (this.wallpaperExternalHelper.isExternalScene()) {
        this.doSendData();
      } else {
        this.changeWindowMode(false);
        if (NavigationUtil.isNavToScreenlockEditor(this.bundleSource)) {
          NavigationUtil.doPageBack();
        } else if (DeviceHelper.isSettingSplitProduct()) {
          this.doSendData();
        } else {
          this.pageInfos.pop();
        }
      }
    } else {
      // demo
      this.pageInfos.pop();
    }
  }

  private setClockEditTimeOut(): void {
    // instrument ignore if
    if (this.isAccessibilityMode) {
      return;
    }
    this.mClockEditAlarmId = setTimeout(() => {
      // instrument ignore else
      if (!LayoutGridTool.isDragState && !this.isFormEditAllPanelShow()) {
        this.resetClockWidgetDefault();
      }
    }, DISAPPEAR_TIME);
  }

  // 仅保存锁屏编辑数据
  private async applyClockConfig(): Promise<void> {
    this.isLockScreenSelected = true;
    this.isHomeScreenSelected = false;
    // 保存景深数据
    this.snapshotPromise = this.loadPreviewsIfNecessary();
    const param: MultiWallpaperConfigParams = {
      isHomeScreenSelected: this.isHomeScreenSelected,
      isLockScreenSelected: this.isLockScreenSelected,
      singleThemeConfigParamsArray: this.createSingleThemeConfigParamArray(),
      wallpaperSourceType: WallpaperSourceType.UNKNOWN,
      imageSaliency: undefined,
      tsAdapter: this.themeAdapter,
      isHomeScreenBlur: false,
      isLockScreenBlur: this.isLockscreenBlur,
      blurRadius: this.blurRadius,
      wallpaperCacheName: '',
      dofCacheName: ''
    };
    if (this.screenLockEditorPageCtlData?.isWallpaperEditable) {
      Log.info(TAG, `applyClockConfig setWallpaper`);
      await this.applyWallpaper();
    } else {
      await this.wallpaperFileManager.saveClockConfig(param);
    }
    Log.info(TAG, 'applyClockConfig done');
  }

  private async applyWallpaper() {
    let shouldQuit: boolean = false;
    try {
      await this.snapshotPromise;
    } catch (e) {
      this.loadingController?.close();
      this.isHideTopButton = false;
      this.isHideBottomButton = false;
      return;
    }
    // 同步壁纸给外屏
    this.sendUrlToSubScreen();

    let writers: WallpaperWriter[] =
      this.qualifierManager.getWritersToApply(this.isSetTabQualifierOnly, this.tabQualifier);
    let applyRes: boolean = false;
    try {
      // 壁纸图写入本地缓存
      applyRes = await this.setWallpaper(writers);
      shouldQuit = true;
    } catch (err) {
      Log.error(TAG, `enable theme err: ${err}`);
      this.isLoading = false;
      this.isHideBottomButton = false;
      this.isHideTopButton = false;
      if (this.wallpaperExternalHelper.isExternalScene()) {
        try {
          NavigationUtil.session?.sendData({ 'success': false, 'type': this.wallpaperApplyType });
        } catch (err) {
          Log.error(TAG, `send Msg error: ${err?.code}`);
        }
      }
      this.reportApplyOrCancel(false);
    } finally {
      // need to delete wallpaperCache
      this.qualifierManager.clearAllWallpaperCacheFile(this.isApplyWatch ?
        this.watchFaceHelper.watchFaceHasTransferred : true);
      this.wallpaperFileManager.clearCachedDirs();
      this.isHideTopButton = true;
      if (!applyRes) {
        this.quitLoadingAndBack(applyRes);
      } else {
        if (shouldQuit) {
          this.mAlarmId = setTimeout(() => {
            // 退出壁纸编辑
            this.quitLoadingAndBack(applyRes);
          }, APPLY_TIME);
        } else {
          this.isInProgress = false;
          this.loadingController?.close();
        }
      }
    }
  }

  private async setWallpaper(writers: WallpaperWriter[]) {
    let wallpaperCacheName: string =
      await this.wallpaperFileManager.writeWallpapersToCacheDir(writers, undefined, this.tabQualifier);
    const imageSaliency: ImageSaliency | undefined = await this.getImageSaliency();
    // config.json、wallpaper_config.json落盘
    await this.saveWallpaperConfigs(wallpaperCacheName, imageSaliency);

    // 历史壁纸数据落盘
    await this.saveHistoryConfigs(imageSaliency);

    let wallpaperInfos: WallPaperInfo[] =
      this.qualifierManager.generateWallpaperInfos(this.isSetTabQualifierOnly, this.tabQualifier,
        this.generateWallpaperParams());
    // instrument ignore else
    if (wallpaperInfos.length > 0) {
      this.fillOnlineImageInfo(wallpaperInfos);
      wallpaperInfos.forEach(wallpaperInfo => {
        Log.info(TAG, `wallpaperInfo Contains: ${StringUtil.arrayToString(wallpaperInfo.wallPapers)}`);
      });

      // 通知TS壁纸使能
      let applyRes: boolean = await this.themeAdapter.setWallpaper(this.getUIContext(), wallpaperInfos);
      Log.info(TAG, `setWallpaper, applyRes = ${applyRes}`);
      this.reportApplyOrCancel(true);
      return applyRes;
    }
    return false;
  }

  private quitLoadingAndBack(applyRes: boolean): void {
    Log.info(TAG, `quitLoadingAndBack, this.isLoading = ${this.isLoading}`);
    if (!this.isLoading) {
      return;
    }
    this.isLoading = false;
    this.isInProgress = true;
    this.loadingController?.close();
    if (applyRes) {
      this.applyThemeBack();
    }
  }

  private fillOnlineImageInfo(wallpaperInfos: WallPaperInfo[]): void {
    // instrument ignore else
    if (this.imageId === '') {
      return;
    }
    wallpaperInfos.forEach((wallpaperInfo: WallPaperInfo) => {
      wallpaperInfo.wallPapers?.forEach((wallpaper: WallPaper) => {
        wallpaper.id = this.imageId;
        wallpaper.origin = this.imageOrigin;
      });
    });
  }

  private async sendUrlToSubScreen(): Promise<void> {
    // instrument ignore if
    if (DeviceHelper.isNexSmallFold() && this.isApplySubScreen) {
      const path: string = this.params.imageURL ?? '';
      let subScreenHelper: SubScreenHelper = new SubScreenHelper();
      try {
        let result: boolean = await subScreenHelper.setSubScreen(path);
        Log.info(TAG, `setSubScreen: ${result}`);
      } catch (error) {
        Log.error(TAG, `setSubScreen error ${error?.code}`);
      }
    }
  }

  private async saveWallpaperConfigs(wallpaperCacheName: string, imageSaliency?: ImageSaliency): Promise<void> {
    await this.wallpaperFileManager.saveMultiWallpaperConfig(this.generateMultiWallpaperConfigParams(imageSaliency,
      wallpaperCacheName));
  }

  private generateMultiWallpaperConfigParams(imageSaliency: ImageSaliency | undefined,
    wallpaperCacheName: string): MultiWallpaperConfigParams {
    return {
      isHomeScreenSelected: this.isHomeScreenSelected,
      isLockScreenSelected: this.isLockScreenSelected,
      singleThemeConfigParamsArray: this.createSingleThemeConfigParamArray(),
      wallpaperSourceType: this.params.wallpaperSourceType ?? WallpaperSourceType.UNKNOWN,
      imageSaliency: imageSaliency,
      tsAdapter: this.themeAdapter,
      isHomeScreenBlur: this.isDesktopBlur,
      isLockScreenBlur: this.isLockscreenBlur,
      blurRadius: this.blurRadius,
      wallpaperCacheName: `${wallpaperCacheName}.jpg`,
      dofCacheName: `${wallpaperCacheName}_dof.png`,
    };
  }

  private async saveHistoryConfigs(imageSaliency: ImageSaliency | undefined): Promise<void> {
    if (this.params.shouldSaveHistoryWallpaperData && this.isHomeScreenSelected) {
      try {
        const originWallpaperHash: string = await FileUtil.getFileHash(this.qualifierManager
          .getWallpaperWriter(WallpaperQualifier.BASE)?.originWallpaperModel.src);
        let rectDataArray: WallpaperRectData[] = [];
        let lockDataArray: LockScreenData[] = [];
        let dofWallpaperPath: string | undefined = undefined;
        if (this.isLockScreenSelected) {
          for (const qualifier of this.allQualifiers) {
            rectDataArray.push(new WallpaperRectData(qualifier, this.qualifierManager.getDisplayRect(qualifier)));
            lockDataArray.push(new LockScreenData(qualifier, this.clockDataManager.getLockConfig(qualifier)));
          }
          dofWallpaperPath = (this.qualifierManager
            .getWallpaperWriter(WallpaperQualifier.BASE)?.dofWallpaperModel?.src) ?? '';
        }
        await HistoryWallpaperUtil.saveHistoryWallpaperData({
          imageHash: originWallpaperHash,
          originWallpaperPath: this.qualifierManager
            .getWallpaperWriter(WallpaperQualifier.BASE)?.originWallpaperModel.src ?? '',
          dofWallpaperPath: dofWallpaperPath,
          rectDataArray: rectDataArray.length > 0 ? rectDataArray : undefined,
          lockScreenDataArray: lockDataArray.length > 0 ? lockDataArray : undefined,
          imageSaliency: imageSaliency,
        });
      } catch (err) {
        Log.error(TAG, `error before updateMyWallpaperFile: ${err?.code}, ${err?.message}`);
      }
    }
  }

  private updateSurfaceRect(currRect: SurfaceRect, isHidden: boolean) {
    let viewRect = CAMMOVER_SERVICE.updateSurfaceRect(
      currRect.offsetX === undefined ? 0 : currRect.offsetX,
      currRect.offsetY === undefined ? 0 : currRect.offsetY,
      currRect.surfaceWidth, currRect.surfaceHeight, isHidden);
    currRect.offsetX = Number(viewRect.x);
    currRect.offsetY = Number(viewRect.y);
    currRect.surfaceWidth = Number(viewRect.width);
    currRect.surfaceHeight = Number(viewRect.height);
  }

  private calculatePreviewImageRatio(width: number): number {
    let isLand = DeviceHelper.isLandScape();
    let landRatio = (this.isPad ? // 预览框上的预览比例
      RES_MGR.getNumberByResource($r('app.float.wallpapereditor_pad_preview_land_width')) :
      RES_MGR.getNumberByResource($r('app.float.wallpapereditor_fold_land_preview_image_width'))) / width;
    let baseRatio = (this.isPad ? RES_MGR.getNumberByResource($r('app.float.wallpapereditor_preview_image_width_pad')) :
      RES_MGR.getNumberByResource($r('app.float.wallpapereditor_preview_image_width'))) / width;
    let ratio = 1.0;
    // instrument ignore if
    if (this.isPad) {
      ratio = isLand ? landRatio : baseRatio;
    } else if (this.isBigFold) {
      try {
        let isFoldExpand = DeviceHelper.isFoldExpanded();
        let previewUnfoldWidth = isFoldExpand ?
          RES_MGR.getNumberByResource($r('app.float.wallpapereditor_fold_preview_image_width')) :
          RES_MGR.getNumberByResource($r('app.float.wallpapereditor_extra_fold_preview_image_width'));
        let unfoldRatio = previewUnfoldWidth / width;
        // instrument ignore else
        if (isFoldExpand) {
          ratio = isLand ? landRatio : unfoldRatio;
        } else {
          ratio = baseRatio;
        }
      } catch (error) {
        Log.error(TAG, `calculate big fold preview image ratio error: ${error?.code}`);
      }
    }
    return ratio;
  }

  private configPreviewImageRect(currRect: SurfaceRect) {
    this.autoResize = (!this.isBigFold && !this.isPad);
    // instrument ignore else
    if ((this.isBigFold) || this.isPad) {
      this.camMoverImageRect.x =
        (currRect.offsetX === undefined || !this.isUnfold) ? 0 : currRect.offsetX * -1;
      this.camMoverImageRect.y =
        (currRect.offsetY === undefined || !this.isUnfold) ? 0 : currRect.offsetY * -1;
      // instrument ignore if
      if (this.isPad) {
        this.camMoverImageRect.x = 0;
        this.camMoverImageRect.y = 0;
      }
      this.camMoverImageRect.width = currRect.surfaceWidth;
      this.camMoverImageRect.height = currRect.surfaceHeight;
      this.camMoverImageRect.ratio = this.calculatePreviewImageRatio(px2vp(this.camMoverImageRect.width));
      Log.info(TAG, `==ratio=${this.camMoverImageRect.ratio}, w=${this.camMoverImageRect.width}`);
    }
  }

  private surfaceChangedCallback(surfaceId: string, currRect: SurfaceRect, hiddenRect?: SurfaceRect) {
    // 先更新状态再传坐标
    let isFolded: boolean = DeviceHelper.isFoldFolded(); // 折叠屏展开态，直板机默认
    let screenStatus: Number = CAMMOVER_SERVICE.getCurScreenStatus(this.isShowDesktop);
    CAMMOVER_SERVICE.setDeviceInfo(isFolded, screenStatus);
    Log.info(TAG, `surface id ${surfaceId} change:(x:${currRect.offsetX}, y:${currRect.offsetY}),
              (w:${currRect.surfaceWidth}, h:${currRect.surfaceHeight})`);
    this.updateSurfaceRect(currRect, false);
    // instrument ignore else
    if (hiddenRect !== undefined) {
      this.updateSurfaceRect(hiddenRect, true);
    }
    this.configPreviewImageRect(currRect);
  }

  private surfaceCreatedCallback(surfaceId: String) {
    Log.info(TAG, `set cammover preview window with surface id ${surfaceId}`);
    CAMMOVER_SERVICE.setSurfacePreview(surfaceId);
  }

  private async onCamMoverAppear() {
    setTimeout(() => {
      this.doShowDesktop();
    }, 700);
    CAMMOVER_SERVICE.render2Surface(true)
      .then(() => {
        this.isHideTopButton = false;
        this.isHideBottomButton = false;
        this.isRendering = false;
      });
  }

  @Builder
  showCamMoverPreview() {
    if (this.usingCamMover() && this.cameraMoverSuccess) {
      CamMoverPreview({
        isChange: this.isChange,
        allResolutions: this.resolutionMap,
        expandPercent: CAMERA_MOVER_EXPAND_PERCENT,
        showPreview: this.showCMPreview,
        surfaceChangedCallback: (surfaceId: string, currRect: SurfaceRect, hiddenRect?: SurfaceRect) => {
          this.surfaceChangedCallback(surfaceId, currRect, hiddenRect);
        },
        surfaceCreatedCallback: (surfaceId: String) => {
          this.surfaceCreatedCallback(surfaceId);
        },
      }).onAppear(async () => {
        this.onCamMoverAppear();
      })
        .onDisAppear(() => {
          CAMMOVER_SERVICE.unInitService();
        })
        .visibility(this.cameraMoverSuccess ? Visibility.Visible : Visibility.None);
    }
  }

  @Builder
  editWallpaper(enableGestures: boolean = true) {
    Stack() {
      this.showCamMoverPreview();
      EditWallpaper({
        clockWidgetEditDefault: true,
        clockWidgetAdapter: this.adapter,
        rgbaPixelMap: this.rgbaPixelMap,
        isClockEditable: this.supportEdit,
        isUnlockVisualEffectEnabled: this.isLockscreenBlur,
        isDesktopVisualEffectEnabled: this.isDesktopBlur,
        blurRadius: this.blurRadius,
        imagePixelMap: this.wallpaperPixelMap,
        targetRect: this.targetRect,
        unfoldTargetRect: this.unfoldTargetRect,
        landTargetRect: this.landTargetRect,
        isImageLoaded: this.isImageLoaded,
        isUnfoldImageLoaded: this.isUnfoldImageLoaded,
        isLandImageLoaded: this.isLandImageLoaded,
        isShowDesktop: this.isShowDesktop,
        isShowEffect: this.params.imageAesthetic,
        isZoomed: this.isZoomed,
        physicalScale: this.physicalScale,
        isDesktopReady: this.isDesktopReady,
        isSlowMomentSuccess: this.isSlowMomentSuccess,
        originImageCompleteCallback: () => {
          this.wallpaperChange.originRect = this.qualifierManager.getDisplayRect(this.currentQualifier);
          CacheManger.editSession().setOriginRect(this.allQualifiers, this.currentQualifier);
          this.wallpaperExternalHelper.imageCompleteCallback();
          this.originPixelMapReady = true;
          if (!this.isFromBindSheet && this.navBackgroundColor !== Color.Black) {
            Log.info(TAG, `update nav background color to black`);
            NavigationUtil.doSetSystemBarColor('white');
            this.navBackgroundColor = Color.Black;
          }
          if (ShareTransitionUtil.animationFinished && this.navBackgroundColor !== Color.Black) {
            this.navBackgroundColor = Color.Black;
          }
          if (this.isScreenLockSCBSource()) {
           setTimeout(() => {
              if (this.screenLockEditorPageCtlData) {
                this.screenLockEditorPageCtlData.isCanShowWallpaperContent = true;
              }
           }, SCREEN_LOCK_WALLPAPERCONTENT_DELAY);
          }
        },
        isFromSheetWallpaperPicker: this.exitWallpaperEditor !== undefined,
        enableGestures: enableGestures, // 由锁屏进入编辑，禁用壁纸编辑
        isScreenLockSCBSource: this.isScreenLockSCBSource(),
        wallpaperOpacityAniEnable: this.isWallpaperOpacityAnimationEnable(),
        wallpaperScaleEnable: this.isWallpaperScaleEnable(),
      })
        .id('EditWallpaper')
        .visibility(this.cameraMoverSuccess ? Visibility.None : Visibility.Visible);

    }
    .focusable(false)
    .id('editWallpaper')
    .width('100%')
    .height('100%')
    .accessibilityLevel('no')
    .hitTestBehavior(this.refreshClockData.showAiArtFontPage ? HitTestMode.Block : HitTestMode.Default);
  }

  private isWallpaperOpacityAnimationEnable(): boolean {
    // 大桌面锁屏拉起的锁屏编辑，需要使能透明度动画, 避免动态主题壁纸跳变
    return this.isScreenLockKGSource();
  }

  private isWallpaperScaleEnable(): boolean {
    // 非锁屏编辑场景，维持原状；使能壁纸缩放
    if (!this.isScreenLockSCBSource()) {
      return true;
    }

    // 锁屏编辑场景，如果壁纸不支持编辑(非电影运镜场景)，比如官方主题壁纸、在线壁纸等，关闭壁纸缩放
    if (!this.screenLockEditorPageCtlData?.isWallpaperEditable && !this.screenLockEditorPageCtlData?.isCammover) {
      return false;
    }

    // 锁屏编辑场景——非双指捏合场景：支持编辑的壁纸，使能缩放
    if (!this.isScreenLockKGSource()) {
      return true;
    }

    // 锁屏编辑场景——双指捏合场景：首次进入不使能缩放；后续操作是否使能缩放，由外部控制
    return this.wallpaperScaleEnable;
  }

  private clearClockEditAlarm(): void {
    if (this.mClockEditAlarmId !== -1) {
      clearTimeout(this.mClockEditAlarmId);
      this.mClockEditAlarmId = -1;
    }
  }

  private buttonGroupLeftCallback(): void {
    Log.info(TAG, 'FloatingButtonGroup leftCallback');
    if (this.isScreenLockKGSource()) {
      NavigationUtil.session?.sendData({ 'cancel': true });
      return;
    }
    HiSysEventUtil.reportWallpaperEditorApplyOrCancel(FloatingButtonType.CANCEL, this.markWallpaperEntrance());
    this.hasReturn = true;
    // instrument ignore else
    if (this.source === Constants.WALLPAPER_PICKER) {
      emitter.emit(EventId.BACK_TO_WALLPAPER_PICKER);
    }
    // instrument ignore if
    if (this.exitWallpaperEditor) {
      this.isExiting = true;
      this.navBackgroundColor = Color.Transparent;
      this.exitWallpaperEditor();
    } else {
      this.needFreeze = true;
      NavigationUtil.doSetSystemBarColor('reset');
      // instrument ignore if
      if (NavigationUtil.session) {
        if (this.wallpaperExternalHelper.isExternalScene()) {
          this.doSendData();
        } else {
          this.changeWindowMode(false);
          if (NavigationUtil.isNavToScreenlockEditor(this.bundleSource)) {
            NavigationUtil.doPageBack();
          } else if (DeviceHelper.isSettingSplitProduct() && !this.isFromHomeOrLock) {
            Log.info(TAG, `isSettingSplitProduct is true and isFromHomeOrLock is false`);
            this.doSendData();
          } else {
            this.pageInfos.pop();
          }
        }
        this.resetClockWidgetDefault();
      } else {
        // instrument ignore if
        if (this.pageInfos.size() <= 1) {
          // setting
          try {
            (getContext() as common.UIAbilityContext).terminateSelf();
          } catch (e) {
            Log.error(TAG, 'terminateSelf error');
          }
        } else {
          // demo
          this.pageInfos.pop();
        }
      }
    }
  }

  @Builder
  buttonGroup(showRegularTopButton: boolean) {
    FloatingButtonGroup({
      bottomRightImage: this.desktopPreviewIcon,
      desktopPreviewFont: this.desktopPreviewFont,
      isFromBindSheet: this.isFromBindSheet,
      isHideTopButton: this.isApplySheetShow || this.isHideTopButton || this.waitingCamMoverMesh() ||
      this.refreshClockData.clockRefreshing,
      isHideBottomButton: this.isApplySheetShow || this.isHideBottomButton || this.waitingCamMoverMesh() ||
      this.refreshClockData.clockRefreshing,
      isShowDesktop: this.isShowDesktop,
      isEnabled: this.isImageLoaded,
      isShowPopup: this.isShowPopup,
      isSlowMomentSuccess: this.isSlowMomentSuccess,
      isShowTip: this.isShowTip,
      isHighlighted: this.isShowDesktop ? this.isDesktopBlur : this.isLockscreenBlur,
      blurRadius: this.blurRadius,
      isSliderChanging: this.isSliderChanging,
      isShowRegularTopButton: showRegularTopButton,
      isWallpaperEditable: this.isScreenLockSCBSource() ? (this.screenLockEditorPageCtlData?.isClockVisible &&
        this.screenLockEditorPageCtlData?.isCanShowWallpaperContent) : true,
      isNewMaterialSupported: this.isNewMaterialSupported,
      isFocusCancel: this.isFocusCancel,
      leftCallback: () => {
        this.buttonGroupLeftCallback();
      },
      rightCallback: () => {
        Log.info(TAG, 'FloatingButtonGroup rightCallback');
        HiSysEventUtil.reportWallpaperEditorApplyOrCancel(FloatingButtonType.APPLY, this.markWallpaperEntrance());
        if (this.isScreenLockSCBSource()) {
          this.isLoading = true;
          this.resetClockWidgetDefault();
          this.loadingController?.open();
          this.applyClockConfig();
          this.isHideTopButton = true;
          return;
        }
        this.updateBlurRadius();
        // instrument ignore else
        if (!this.isApplySheetShow) {
          this.isApplySheetShow = true;
          this.wallpaperDisplaySync.on('frame', (frameInfo: displaySync.IntervalInfo) => {
            Log.info(TAG, 'start to open ApplySheet');
            this.openDialogController();
            this.resetClockWidgetDefault();
            // 确保运镜默认情况点击应用时, 锁屏和桌面都是勾选状态
            if (this.usingCamMover()) {
              this.isLockScreenSelected = true;
              this.isHomeScreenSelected = true;
            }
            this.wallpaperDisplaySync.stop();
            this.wallpaperDisplaySync.off('frame');
          });
          this.wallpaperDisplaySync.start();
        }
      },
      camMoverCallback: async () => {
        // instrument ignore else
        if (this.enableCamMover) {
          this.showCMPreview = !this.showCMPreview;
          this.clearClockEditAlarm();
          // instrument ignore if
          if (!this.showCMPreview) {
            this.cameraMoverSuccess = false;
            HiSysEventUtil.reportCameraMoverSelect(false, this.markWallpaperEntrance());
          } else {
            HiSysEventUtil.reportCameraMoverSelect(true, this.markWallpaperEntrance());
            await this.loadCamMover()
              .then((ret: Number) => {
                // instrument ignore if
                if (ret.valueOf() !== 0) {
                  Log.error(TAG, 'cammover init failed, will not enable to use cammover');
                }
              });
          }
        }
      },
      bottomLeftCallback: () => {
        this.isVirtualEffect = true;

        if (this.isAesSuccess && !this.isReportedChange) {
          HiSysEventUtil.reportChangeAesthetic(this.markWallpaperEntrance());
          this.isReportedChange = true;
        }
        Log.info(TAG, 'FloatingButtonGroup bottomLeftCallback');
        this.isInProgress = true;
        this.isEdited = true;

        if (this.isShowDesktop) {
          // instrument ignore else
          if (this.enableCamMover) {
            if (!this.secondBlurButton) {
              this.showCamMoverButton = !this.showCamMoverButton;
            }
          }
          this.firstBlurButton = !this.firstBlurButton;
          animateTo({
            duration: 200, // 时长200ms
            curve: Curve.Smooth,
          }, () => {
            this.isDesktopBlur = !this.isDesktopBlur;
          });
          Log.info(TAG, `refresh isDesktopBlur= ${this.isDesktopBlur}`);
          this.baseWallpaperProp.isDesktopBlur = this.isDesktopBlur;
          this.unfoldedWallpaperProp.isDesktopBlur = this.isDesktopBlur;
          this.landWallpaperProp.isDesktopBlur = this.isDesktopBlur;
          this.unfolded2WallpaperProp.isDesktopBlur = this.isDesktopBlur;
          this.land2WallpaperProp.isDesktopBlur = this.isDesktopBlur;
          // instrument ignore else
          if (this.isDesktopBlur) {
            HiSysEventUtil.reportWallpaperBlur(true, WallpaperBlurType.DESKTOP, this.markWallpaperEntrance());
          } else {
            HiSysEventUtil.reportWallpaperBlur(false, WallpaperBlurType.DESKTOP, this.markWallpaperEntrance());
          }
        } else {
          this.secondBlurButton = !this.secondBlurButton;
          // instrument ignore else
          if (this.enableCamMover) {
            if (!this.firstBlurButton) {
              this.showCamMoverButton = !this.showCamMoverButton;
            }
          }
          this.isLockscreenBlur = !this.isLockscreenBlur;
          Log.info(TAG, `refresh isLockscreenBlur= ${this.isLockscreenBlur}`);
          this.baseWallpaperProp.isLockScreenBlur = this.isLockscreenBlur;
          this.unfoldedWallpaperProp.isLockScreenBlur = this.isLockscreenBlur;
          this.landWallpaperProp.isLockScreenBlur = this.isLockscreenBlur;
          this.unfolded2WallpaperProp.isLockScreenBlur = this.isLockscreenBlur;
          this.land2WallpaperProp.isLockScreenBlur = this.isLockscreenBlur;
          // instrument ignore else
          if (this.isLockscreenBlur) {
            HiSysEventUtil.reportWallpaperBlur(true, WallpaperBlurType.UNLOCK, this.markWallpaperEntrance());
          } else {
            HiSysEventUtil.reportWallpaperBlur(false, WallpaperBlurType.UNLOCK, this.markWallpaperEntrance());
          }
        }
      },
      bottomRightCallback: () => {
        Log.info(TAG, 'FloatingButtonGroup bottomRightCallback');
        this.isShowDesktop = !this.isShowDesktop;
        if (this.isShowDesktop) {
          this.count++;
        }

        this.isChangedPreview = true;
        CacheManger.editSession().setChangedPreview(this.tabQualifier, true);
        this.resetClockWidgetDefault();
        HiSysEventUtil.reportChangePreview(ChangeClickType.BUTTON, this.markWallpaperEntrance());
        this.desktopPreviewIcon = this.isShowDesktop ? $r('app.media.ic_public_desktop_preview_selected') :
          $r('app.media.ic_public_desktop_preview');
        this.desktopPreviewFont =
          this.isShowDesktop ? $r('app.string.homescreen_preview') : $r('app.string.lockscreen_preview');
        if (this.isShowDesktop) {
          this.clearClockEditAlarm();
        }
        // instrument ignore if
        if (this.cameraMoverSuccess) {
          let screenStatus: Number = CAMMOVER_SERVICE.getCurScreenStatus(this.isShowDesktop);
          let isFolded: Boolean = CAMMOVER_SERVICE.getIsFolded();
          CAMMOVER_SERVICE.setDeviceInfo(isFolded, screenStatus);
        }
      },
      cardSelectCallback: this.getCardSelectCallback(),
    })
      .height('100%')
      .width('100%')
      .hitTestBehavior(HitTestMode.Transparent)
      .zIndex(3); // 层级数为3
  }

  /**
   * 获取壁纸选中回调 , 三折叠设备中使用 , 其他设备中为空
   *
   * @returns 壁纸选中回调,可为空
   */
  private getCardSelectCallback(): Nullable<(param: EnterWallpaperEditorParam,
    callback: (isClickOk: boolean) => void) => void> {
    Log.info(TAG, 'cardSelectCallback , not need create');
    this.cardSelectCallback = undefined;
    return this.cardSelectCallback;
  }

  private isClickInEditSheet(fingerInfo: FingerInfo): boolean {
    const isInEditToolBar: boolean = this.isInComponentArea(fingerInfo, IDConstants.EDIT_TOOLBAR_ID);
    const isInFont: boolean = this.isInComponentArea(fingerInfo, IDConstants.FONT_PANE_ID);
    const isInColor: boolean = this.isInComponentArea(fingerInfo, IDConstants.COLOR_PANE_ID);
    const isInLayout: boolean = this.isInComponentArea(fingerInfo, IDConstants.LAYOUT_PANE_ID);
    const isInSign: boolean = this.isInComponentArea(fingerInfo, IDConstants.SIGNATURE_PANE_ID);
    return isInEditToolBar || isInFont || isInColor || isInLayout || isInSign;
  }

  // 更换壁纸过程中按钮置灰，不响应点击事件
  @Styles
  changeWallpaperStyle() {
    .opacity(0.6) // 更换壁纸时按钮透明度为0.4
    .onTouchIntercept((event: TouchEvent) => {
      return HitTestMode.Block;
    });
  }

  private getScreenLockEditPanelSize(): SizeOptions {
    let area: SizeOptions = {};
    area.width = this.qualifierManager.getDeviceSize(this.tabQualifier)[0] * // 大预览小，调整width、height
      (this.physicalScale > 1 ? this.physicalScale : SCALE_ORIGIN);
    area.height = this.qualifierManager.getDeviceSize(this.tabQualifier)[1] *
      (this.physicalScale > 1 ? this.physicalScale : SCALE_ORIGIN);
    Log.error(TAG, `getScreenLockEditPanelSize: ${area.width} ${area.height}`);
    return area.width * area.height > 0 ? area : {width: '100%', height: '100%'};
  }

  @Builder
  buttonGroupContent() {
    if (this.isLoadTopButton) {
      EffectComponent() {
        this.buttonGroup(this.isScreenLockSCBSource())
      }
      .backgroundEffect({
        policy: 1,
        radius: 60,
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .id('buttonGroup_Effect')
      .freeze(this.needFreeze)
      .zIndex(3)
      .changeWallpaperStyle()
      .onAppear(() => {
        // 如果存在点阵动效，等动效结束主动聚焦取消按钮
        setTimeout(() => {
          if ((this.refreshWallpaperBasicData.forceRipple || this.isNeedRippleEffect() && this.isAccessibilityMode) &&
            !this.isFocusCancel) {
            Log.info(TAG, `toggleFocus cancel.`);
            accessHelper.toggleFocus(Constants.CANCEL_BTN_ID);
          }
        }, TOGGLE_FOCUS_DELAY);
      });
    }
  }

  @Builder
  wallpaperContent() {
    Stack() {
      EffectComponent() {
        if (this.currentQualifier === WallpaperQualifier.BASE) {
          ScreenLockEditPanel({
            isWallpaperEdit: this.isWallpaperEdit(),
            adapter: this.adapter,
            isEditArtBtnShow: !this.wallpaperScaleEnable && this.isScreenLockKGSource(),
            dofWallpaperImg: this.aesUiSwitchSet.dofImage,
            formConfig: this.formConfig,
            initalWithPreview: this.isSupportScreenLockEdit(),
            supportEdit: this.isSupportScreenLockEdit(),
            clockStyle: this.clockObject,
            singleGridSize: this.gridWidth,
            needReloadForm: this.clockUiSwitchSet.baseNeedReloadForm,
            isShowEffect: this.params.imageAesthetic,
            initEditState: this.getEditState(),
          });
        }

        if (this.currentQualifier === WallpaperQualifier.UNFOLDED && !this.isLand) { // 大折叠展开态竖屏时钟
          ScreenLockEditPanel({
            isWallpaperEdit: true,
            adapter: this.adapter,
            isEditArtBtnShow: !this.wallpaperScaleEnable && this.isScreenLockKGSource(),
            dofWallpaperImg: this.aesUiSwitchSet.unfoldDofImage,
            formConfig: this.formConfig,
            initalWithPreview: this.supportEdit,
            supportEdit: this.supportEdit,
            clockStyle: this.unfoldClockObject,
            singleGridSize: this.gridWidth,
            needReloadForm: this.clockUiSwitchSet.unfoldNeedReloadForm,
            isShowEffect: this.params.imageAesthetic,
            initEditState: this.getEditState(),
          });
        }

        if (this.currentQualifier === WallpaperQualifier.LAND ||
          this.currentQualifier === WallpaperQualifier.UNFOLDED_LAND) { // 横屏时钟
          ScreenLockEditPanel({
            isWallpaperEdit: true,
            adapter: this.adapter,
            isEditArtBtnShow: !this.wallpaperScaleEnable && this.isScreenLockKGSource(),
            dofWallpaperImg: this.aesUiSwitchSet.landDofImage,
            formConfig: this.formConfig,
            initalWithPreview: this.supportEdit,
            supportEdit: this.supportEdit,
            clockStyle: this.landClockObject,
            singleGridSize: this.gridWidth,
            needReloadForm: this.clockUiSwitchSet.landNeedReloadForm,
            isShowEffect: this.params.imageAesthetic,
            initEditState: this.getEditState(),
          });
        }
      }
      .backgroundEffect({
        policy: 1,
        radius: 25,
      })
      .freeze(this.needFreeze)
      .visibility(!this.isShowDesktop ? Visibility.Visible : Visibility.Hidden)
      .hitTestBehavior(!this.isShowDesktop && !this.refreshClockData.clockRefreshing ? HitTestMode.Transparent :
        HitTestMode.Block);
    }
    .focusable(false)
    .zIndex(this.clockWidgetEdit ? 1 : 0)
    .accessibilityLevel('no')
    .transition(!this.isScreenLockKGSource() ? AnimationUtil.getClockInAndOutOpacityEffect() : null)
    .hitTestBehavior(HitTestMode.Transparent)
    .onAppear(async () => {
      // 获取第一次加载时钟组件区域颜色
      if (this.adapter && this.adapter.getDataManager().getSlClockBindState() && this.wallpaperPixelMap) {
        this.adapter.getDataManager().getSlClockBindState().colorStypeInputData =
          new ColorStyleInputData(this.wallpaperPixelMap, this.getClockWidgetPosition(), this.getDevicePosition());
      }
    })
    .parallelGesture(TapGesture({ count: 1 })
      .onAction(async (event: GestureEvent) => {
        this.hasClockAction = true;
        // instrument ignore if
        if (this.dragFinished) {
          this.dragFinished = false;
          Log.info(TAG, 'dragFinished, just back');
          // 拖拽事件结束后都要重新获取时钟组件区域颜色
          if (this.adapter && this.adapter.getDataManager().getSlClockBindState()) {
            const inputData = this.adapter.getDataManager().getSlClockBindState().colorStypeInputData;
            if (inputData) {
              inputData.devicePosition = this.getDevicePosition();
              inputData.position = this.getClockWidgetPosition();
            }
          }
          return;
        }
        this.clearClockEditAlarm();
        // instrument ignore if
        if (!event.fingerList[0]) {
          Log.error(TAG, 'tap info is error');
          return;
        }
        this.doClockEvent(event);
      }), GestureMask.Normal)
    .width('100%')
    .height('100%')
    .id('ScreenLockStack');

    // instrument ignore if
    if (this.isDesktopReady && !this.isScreenLockSCBSource()) {
      this.desktopContent();
    }
  }

  private isWallpaperEdit(): boolean {
    // 时钟组件根据该字段判断是否显示时钟编辑框, lite产品不显示时钟编辑框
    if (DeviceHelper.isLiteProduct()) {
      Log.info(TAG, 'is lite product');
      return false;
    }
    return true;
  }

  private isSupportScreenLockEdit(): boolean {
    // 时钟组件根据该字段判断是否支持时钟编辑, lite产品不支持时钟编辑
    if (DeviceHelper.isLiteProduct()) {
      return false;
    }
    return this.supportEdit;
  }

  /**
   * 获取屏幕区域位置
   * @returns 位置数组
   */
  private getDevicePosition(): number[] {
    let position: number[] = [];
    const rect: AnyRect =
      WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp, this.baseWallpaperProp.deviceHeight,
        this.baseWallpaperProp.deviceWidth);
    if (this.baseWallpaperProp.imageWidth && this.baseWallpaperProp.imageHeight) {
      let newRectX: number = rect.x + rect.width / 2 - rect.width * MAIN_COLOR_SCALE / 2;
      let newRectY: number = rect.y + rect.height / 2 - rect.height * MAIN_COLOR_SCALE / 2;
      let newRectWidth: number = rect.width * MAIN_COLOR_SCALE;
      let newRectHeight: number = rect.height * MAIN_COLOR_SCALE;
      position[0] = (newRectX / vp2px(this.baseWallpaperProp.imageWidth));
      position[1] = (newRectY / vp2px(this.baseWallpaperProp.imageHeight));
      position[2] = ((newRectX + newRectWidth) / vp2px(this.baseWallpaperProp.imageWidth));
      position[3] = ((newRectY + newRectHeight) / vp2px(this.baseWallpaperProp.imageHeight));
    } else {
      position = [];
    }
    return position;
  }

  /**
   * 获取时钟组件区域位置
   * @returns 位置数组
   */
  private getClockWidgetPosition(): number[] {
    const rect: AnyRect =
      WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp, this.baseWallpaperProp.deviceHeight,
        this.baseWallpaperProp.deviceWidth);
    return [rect.x * rect.ratio, rect.y * rect.ratio, vp2px(this.baseWallpaperProp.imageWidth * rect.ratio),
      vp2px(this.baseWallpaperProp.imageHeight * rect.ratio)];
  }

  private isFormEditPanelShow(): boolean {
    // panel_id
    let componentRectangle: componentUtils.ComponentInfo = componentUtils.getRectangleById('form_recommendlist');
    // instrument ignore if
    if (componentRectangle && componentRectangle.size?.height !== 0) {
      return true;
    } else {
      return false;
    }
  }

  private isFormEditDetailPanelShow(): boolean {
    // detail_id
    let componentRectangle: componentUtils.ComponentInfo = componentUtils.getRectangleById('AddToScreenLockButton');
    // instrument ignore if
    if (componentRectangle && componentRectangle.size?.height !== 0) {
      return true;
    } else {
      return false;
    }
  }

  private isFormEditAllPanelShow(): boolean {
    try {
      return this.isFormEditPanelShow() || this.isFormEditDetailPanelShow();
    } catch (e) {
      Log.error(TAG, 'get panel state error');
      return false;
    }
  }

  private doingCamMover(): boolean {
    return (this.waitingCamMoverMesh() || this.isRendering);
  }

  private tryDoCMSPhoneInfoIfNeed() {
    if (this.cameraMoverSuccess) {
      let screenStatus: Number = CAMMOVER_SERVICE.getCurScreenStatus(this.isShowDesktop);
      let isFolded: Boolean = CAMMOVER_SERVICE.getIsFolded();
      CAMMOVER_SERVICE.setDeviceInfo(isFolded, screenStatus);
    }
  }

  private doClockEvent(event: GestureEvent): void {
    if (DeviceHelper.isLiteProduct()) {
      this.isShowDesktop = !this.isShowDesktop;
      return;
    }
    if (this.doingCamMover()) {
      return;
    }
    let isInClock: boolean = this.isInComponentArea(event.fingerList[0], IDConstants.CLOCK_ID);
    let isInForm: boolean = false;
    for (let i = IDConstants.FORM_CARD_MIN_ID; i <= IDConstants.FORM_CARD_MAX_ID; i++) {
      isInForm = isInForm || this.isInComponentArea(event.fingerList[0], IDConstants.FORM_CARD_PREFIX + `${i}`);
    }
    for (let i = IDConstants.FORM_CARD_MIN_ID; i <= IDConstants.FORM_CARD_MAX_ID; i++) {
      isInForm = isInForm || this.isInComponentArea(event.fingerList[0], IDConstants.FORM_CARD_SOLT_PREFIX + `${i}`);
    }
    // 避免热区误识别,锁屏传递变量
    if (LayoutGridTool.getCardOrCardBorderClickStatus() !== ClickState.NONE) {
      isInForm = isInForm || LayoutGridTool.getCardOrCardBorderClickStatus() === ClickState.CARD ||
        LayoutGridTool.getCardOrCardBorderClickStatus() === ClickState.DELETE_CARD;
      isInClock = isInClock || LayoutGridTool.getCardOrCardBorderClickStatus() === ClickState.CLOCK;
      LayoutGridTool.setCardOrCardBorderClickStatus();
    }
    this.isHideBottomButton = false;
    if ((this.isShowDesktop || (!this.clockWidgetEdit && !isInClock && !isInForm)) && !this.isScreenLockSCBSource()) {
      if (this.isExiting || this.isScreenLockSCBSource()) {
        Log.info(TAG, 'is exiting, do not need response.');
        return;
      }

      this.isShowPopup = false;
      this.isShowDesktop = !this.isShowDesktop;
      if (this.isShowDesktop) {
        this.count++;
      }

      this.desktopPreviewIcon = this.isShowDesktop ? $r('app.media.ic_public_desktop_preview_selected') :
        $r('app.media.ic_public_desktop_preview');
      this.desktopPreviewFont =
        this.isShowDesktop ? $r('app.string.homescreen_preview') : $r('app.string.lockscreen_preview');
      this.resetClockWidgetDefault();
      HiSysEventUtil.reportChangePreview(ChangeClickType.BLANK, this.markWallpaperEntrance());
      this.tryDoCMSPhoneInfoIfNeed();
      return;
    }
    const isInEditSheet = this.isClickInEditSheet(event.fingerList[0]);
    this.hideFloatingButton(isInClock || this.clockWidgetEdit, isInEditSheet, isInForm);
    if (isInClock || isInEditSheet || isInForm) {
      let supportEdit: boolean = this.clockDataManager.getIsClockSupportEdit(this.currentQualifier, this.tabQualifier);
      this.supportEdit = this.physicalScale >= SCALE_ORIGIN || supportEdit;
      this.clockWidgetEdit = this.supportEdit;
      if (!this.supportEdit) { // 小预览大，不支持编辑，弹出气泡提示
        this.isHideBottomButton = false; // 弹出气泡提示 , 不隐藏底部按钮
        let strResource: Resource =
          this.tabQualifier === WallpaperQualifier.UNFOLDED || this.tabQualifier === WallpaperQualifier.UNFOLDED_LAND ?
            $r('app.string.edit_M_tip') : $r('app.string.edit_G_tip');
        promptAction.showToast({ message: strResource });
      }
    } else {
      if (this.isScreenLockSCBSource()) {
        // 由于锁屏点击编辑空白部分不会切换到桌面页，因此不需要重置时钟编辑状态
        this.supportEdit = true;
      } else {
        this.resetClockWidgetDefault();
      }
    }
    const layoutEditManager: LayoutEditManager = this.adapter.getEditHelper().getLayoutEditManger();
    if (layoutEditManager.getEditSt()) {
      this.clockWidgetEdit = false;
    } else {
      this.clockWidgetEdit = true;
    }
    Log.info(TAG, `doClockEvent supportEdit = ${this.supportEdit},clockWidgetEdit:${this.clockWidgetEdit}`);
    if (!this.clockWidgetEdit) {
      this.isHideTopButton = this.clockWidgetEdit;
    }
  }

  private hideFloatingButton(isInClock: boolean, isInEditSheet: boolean, isInForm: boolean) {
    const layoutEditManager: LayoutEditManager = this.adapter.getEditHelper().getLayoutEditManger();
    Log.info(TAG, `isClockWidget is edit default:${layoutEditManager.getEditSt()}`);
    if (isInClock || isInEditSheet || isInForm) {
      if (layoutEditManager.getEditSt()) {
        this.isHideBottomButton = false;
        this.clockWidgetEdit = false;
      } else {
        this.isHideBottomButton = true;
        this.clockWidgetEdit = true;
      }
    }
    if (isInClock || isInEditSheet || isInForm) {
      let supportEdit: boolean = this.clockDataManager.getIsClockSupportEdit(this.currentQualifier, this.tabQualifier);
      this.supportEdit = this.physicalScale >= SCALE_ORIGIN || supportEdit;
      this.clockWidgetEdit = this.supportEdit;
      if (!this.supportEdit) { // 小预览大，不支持编辑，弹出气泡提示
        let strResource: Resource =
          this.tabQualifier === WallpaperQualifier.UNFOLDED || this.tabQualifier === WallpaperQualifier.UNFOLDED_LAND ?
            $r('app.string.edit_M_tip') : $r('app.string.edit_G_tip');
        promptAction.showToast({ message: strResource });
      }
    } else {
      this.resetClockWidgetDefault();
    }
    Log.info(TAG, `doClockEvent supportEdit = ${this.supportEdit},clockWidgetEdit:${this.clockWidgetEdit}`);
    if (!this.clockWidgetEdit) {
      this.isHideTopButton = this.clockWidgetEdit;
    }
  }

  private isInComponentArea(fingerInfo: FingerInfo, componentId: string): boolean {
    let componentRectangle: componentUtils.ComponentInfo = componentUtils.getRectangleById(componentId);
    // instrument ignore if
    if (!componentRectangle.windowOffset) {
      Log.error(TAG, 'componentRectangle info is undefined');
      return false;
    }
    let componentY: number = componentRectangle.windowOffset.y +
      (LayoutGridTool.isShowFormBindSheet ? vp2px(-LayoutGridTool.CLOCK_UP_DISTANCE) : 0);
    return fingerInfo.globalX >= px2vp(componentRectangle.windowOffset.x) &&
      fingerInfo.globalX <= (px2vp(componentRectangle.windowOffset.x) + px2vp(componentRectangle.size.width)) &&
      fingerInfo.globalY >= px2vp(componentY) &&
      fingerInfo.globalY <= (px2vp(componentY) + px2vp(componentRectangle.size.height));
  }


  isNeedWallpaper(): boolean | undefined {
    // instrument ignore if
    if (this.isExiting) {
      return false;
    }
    if (this.params.imageAesthetic || this.isConfiguredPresetWallpaper()) {
      return this.isAesLoaded;
    }
    return this.wallpaperLoaded;
  }

  isNeedLoading(): boolean | undefined {
    return this.params.imageAesthetic && !this.wallpaperLoaded;
  }

  isNeedRippleEffect(): boolean | undefined {
    // 锁屏刚开始进入不需要点阵动画
    if (this.isScreenLockSCBSource()) {
      return false;
    }
    let currentAes: boolean = this.wallpaperLoaded;
    Log.info(TAG, `isNeedRippleEffect, currentAes = ${currentAes}, isTimeout = ${this.isTimeout}`);
    return currentAes && !this.isTimeout;
  }

  isNeedMediaThumbnail(): boolean | undefined {
    return this.wallpaperThumbnailPixel && !this.isZoomed
  }

  // instrument ignore next
  private doResetCameraMoverState() {
    this.showCMPreview = false;
    this.isHideTopButton = false;
    this.isHideBottomButton = false;
    this.isRendering = false;
  }

  doShowDesktop() {
    // 确保锁屏/桌面按钮处于桌面位置
    this.isShowDesktop = !this.isScreenLockSCBSource() ? !this.isShowDesktop : false;
    this.resetClockWidgetDefault();
    this.desktopPreviewIcon = this.isShowDesktop ? $r('app.media.ic_public_desktop_preview_selected') :
      $r('app.media.ic_public_desktop_preview');
    this.desktopPreviewFont =
      this.isShowDesktop ? $r('app.string.homescreen_preview') : $r('app.string.lockscreen_preview');
    // instrument ignore else
    if (this.isShowDesktop) {
      this.clearClockEditAlarm();
    }
    let screenStatus: Number = CAMMOVER_SERVICE.getCurScreenStatus(this.isShowDesktop);
    Log.info(TAG, `Camera mover success setDeviceInfo =${screenStatus}, ${this.isShowDesktop}`);
  }

  @Builder
  wallpaperEditBuilder() {
    Stack() {
      // instrument ignore if
      if (this.thumbnailPixelMap && !this.isMoved && !this.isZoomed) {
        Image(this.thumbnailPixelMap) // 合一编辑缓存的缩略图
          .width('100%')
          .height('100%')
          .syncLoad(true)
          .draggable(false)
          .scale({ x: Constants.LOCK_SCALE, y: Constants.LOCK_SCALE });
      } else if (this.isNeedMediaThumbnail()) {
        Image(this.wallpaperThumbnailPixel) // 图库提供的缩略图
          .width('100%')
          .height('100%')
          .draggable(false)
          .scale({ x: Constants.LOCK_SCALE, y: Constants.LOCK_SCALE })
          .onComplete((event) => {
            Log.info(TAG, `wallpaperThumbnailPixel onComplete`);
            if (event && event.loadingStatus === 1) {
              // instrument ignore if
              if (this.source === THEME_APP_BUNDLE || this.source === PHOTO_APP_BUNDLE) {
                // 语音助手未接入缩略图，此处不接入wallpaperExternalHelper
                Log.info(TAG, 'thumbnailSuccess');
                this.wallpaperDisplaySync.on('frame', (frameInfo: displaySync.IntervalInfo) => {
                  try {
                    Log.info(TAG, 'frame ready, send thumbnailSuccess');
                    NavigationUtil.session?.sendData({ 'thumbnailSuccess': true });
                  } catch (err) {
                    Log.error(TAG, `send Msg error: ${err?.code}`);
                  }
                  this.wallpaperDisplaySync.stop();
                  this.wallpaperDisplaySync.off('frame');
                });
                this.wallpaperDisplaySync.start();
              }
              if (this.wallpaperExternalHelper.imageCompleteCallback) {
                this.wallpaperExternalHelper.imageCompleteCallback();
              }
            }
          });
      } else {
        // None
      }
    }
    .size({
      width: '100%',
      height: '100%',
    })
    .scale(this.getScaleByQualifier(this.currentQualifier))
    .id('ThumbnailLayer');

    if (this.isStaticPhoto) {
      this.editWallpaper();
    }

    if (this.isNeedWallpaper()) {
      // instrument ignore if
      if (!this.params.imageAesthetic) {
        this.editWallpaper();
      }
      // instrument ignore else
      if (this.isShowWallpaperContent()) {
        this.buttonGroupContent();
        this.wallpaperContent();
      }
    } else {
      if (this.isNeedLoading()) {
        Stack() {
          LoadingProgress()
            .width($r('app.float.wallpapereditor_loading_indicator_width'))
            .height($r('app.float.wallpapereditor_loading_indicator_height'));
        }
        .height('100%')
        .width('100%');
      }
    }

    // 需要展示点阵
    if (this.refreshWallpaperBasicData.forceRipple || this.isNeedRippleEffect()) {
      if (!this.isAesLoaded || !this.isExpandHasFinish || !this.isOffRippleEffect ||
      this.refreshWallpaperBasicData.forceRipple) {
        RippleEffect({
          isPauseAnimator: this.isBack,
        })
          .transition(AnimationUtil.getClockInAndOutOpacityEffect());
      }
    }
    //适配电影运镜主题场景代码，为了防止跟美学执行的点阵冲突，单独创建RippleEffect，后续统一整改
    if (this.waitingCamMoverMesh()) {
      RippleEffect()
        .transition(AnimationUtil.getClockInAndOutOpacityEffect())
        .onAppear(() => {
          this.resetClockWidgetDefault();
          this.tryDoCamMover()
            .then((ret: Number) => {
              Log.info(TAG, 'RippleEffect tryDoCamMover');
              this.tryRunMesh()
                .then((mRet: Number) => {
                  // instrument ignore else
                  if (mRet === 0) {
                    Log.info(TAG, 'tryRunMesh done');
                    this.cameraMoverSuccess = true;
                    this.resolutionMap = this.qualifierManager.resolutionMap;
                    this.isRendering = true;
                  } else {
                    Log.error(TAG, 'tryRunMesh failed');
                    this.doResetCameraMoverState();
                  }
                });
            })
            .catch((err: number) => {
              Log.error(TAG, 'tryDoCamMover failed, stop RippleEffect');
              this.doResetCameraMoverState();
            });
        });
    }
  }

  @Builder
  screenLockEditBuilder() {
    if (this.isNeedWallpaper()) {
      if (this.thumbnailPixelMap) {
        Image(this.thumbnailPixelMap) // 合一编辑缓存的缩略图
          .width('100%')
          .height('100%')
          .syncLoad(true)
          .draggable(false)
          .backgroundColor(Color.Transparent)
      }
      Stack() {
        this.editWallpaper(this.screenLockEditorPageCtlData?.isWallpaperEditable);
        if (this.screenLockEditorPageCtlData?.isCanShowWallpaperContent) {
          this.buttonGroupContent();
        }
        // 有时钟时才显示；在搜索跳转的时候会出现时钟编辑回调没有注册，等注册后才能显示
        if (this.screenLockEditorPageCtlData?.isClockVisible &&
          (this.screenLockEditorPageCtlData?.isCanShowWallpaperContent &&
          this.screenLockEditorPageCtlData?.isClockEditStateRegistered || this.isScreenLockKGSource())) {
          this.wallpaperContent();
        }
        if (this.screenLockEditorPageCtlData?.isClockVisible &&
          !this.wallpaperScaleEnable && this.isScreenLockKGSource()) {
          EditArtSignButtonView({adapter: this.adapter})
        }
        Row()
          .border({
            width: $r('app.float.wallpaper_outline_width'),
            color: $r('app.color.button_border_color'),
            radius: $r('app.float.wallpaper_outline_radius'),
            style: BorderStyle.Solid
          })
          .shadow(ShadowStyle.OUTER_DEFAULT_MD)
          .width('100%')
          .height('100%')
          .hitTestBehavior(HitTestMode.Transparent)
          .opacity(this.isLoadTopButton ? 0 : 1)
      }
      // 需要展示点阵
      if (this.refreshWallpaperBasicData.forceRipple || this.isNeedRippleEffect()) {
        if (!this.isAesLoaded || !this.isExpandHasFinish || !this.isOffRippleEffect ||
        this.refreshWallpaperBasicData.forceRipple) {
          RippleEffect({
            isPauseAnimator: this.isBack,
          })
            .transition(AnimationUtil.getClockInAndOutOpacityEffect());
        }
      }
    }
  }

  // 快速进退锁屏时，session赋值有问题，因此只能在settingsthemepage被隐藏后再赋值session
  public setScreenlockSession(): void {
    if (!this.isScreenLockCardSource() || this.screenlockSession === undefined) {
      Log.warn(TAG, `setScreenlockSession failed. session: ${this.screenlockSession}`)
      return;
    }
    NavigationUtil.session = this.screenlockSession;
    // 由于每次壁纸加载好后需要修改session颜色为黑色，而screenlock的session赋值较晚，因此第一次赋值是不生效的，在session赋值后生效
    NavigationUtil.doSetSystemBarColor('white');
    this.changeWindowMode(true);
    NavigationUtil.session?.setReceiveDataCallback(this.dataReceiveCallback());
  }

  build() {
    HdsNavDestination() {
      Stack() {
        if (!this.isScreenLockSCBSource()) {
          this.wallpaperEditBuilder();
        } else {
          this.screenLockEditBuilder();
        }
      }
      .id('wallpaperRoot')
      .align(Alignment.TopStart)
      .backgroundColor(Color.Transparent)
      .height('100%')
      .width('100%')
      .hitTestBehavior(this.isAnimating || !this.isImageLoaded ? HitTestMode.Block : HitTestMode.Transparent);
    }
    .onShown(() => {
      Log.info(TAG, 'onShown , no need start play');
      this.shownCount++;
      // instrument ignore if
      if (this.shownCount > 1 && this.isOffRippleEffect) {
        this.isResPrepared = true;
      }
    })
    .backgroundColor(this.isScreenLockKGSource() ? Color.Transparent : this.navBackgroundColor)
    .onBackPressed(() => {
      return this.onNavBackPress();
    })
    .hideTitleBar(true)
    .hitTestBehavior(HitTestMode.Transparent);
  }

  /**
   * 根据外部拉起源，获取锁屏时钟组件，需要展示的编辑状态
   *
   * @returns 锁屏时钟组件编辑状态
   */
  private getEditState(): Nullable<EditState> {
    Log.info(TAG, `getEditState , source = ${this.source}`);
    if (this.source === Constants.SCREENLOCK_EDIT_DIGITAL_CLOCK ||
      this.source === Constants.SCREENLOCK_EDIT_ART_SIGNATURE ||
      this.source === Constants.MY_WALLPAPER_EDIT_DIGITAL_CLOCK ||
      this.source === Constants.MY_WALLPAPER_EDIT_ART_SIGNATURE) {
      this.isHideBottomButton = true;
      this.clockWidgetEdit = true;
      return EditState.CLOCK_EDIT;
    }
    if (this.source === Constants.SCREENLOCK_EDIT_LOCK_CARD) {
      this.clockWidgetEdit = true;
      return EditState.FORM_EDIT;
    }
    return undefined;
  }

  private isShowWallpaperContent(): boolean {
    Log.info(TAG, `isExpandHasFinish: ${this.isExpandHasFinish}`);
    return this.isExpandHasFinish;
  }

  private isConfiguredPresetWallpaper(): boolean {
    if (this.params.wallpaperSourceType !== WallpaperSourceType.PRESET) {
      return false;
    }
    return !CollectionUtil.isEmpty(this.params.lockScreenDataArray);
  }

  private getScaleByQualifier(qualifier: WallpaperQualifier): ScaleOptions {
    if (qualifier === WallpaperQualifier.UNFOLDED) {
      return {
        x: this.baseWallpaperProp.contentScale,
        y: this.baseWallpaperProp.contentScale,
        centerX: this.baseWallpaperProp.pinchCenterX,
        centerY: this.baseWallpaperProp.pinchCenterY,
      };
    } else if (qualifier === WallpaperQualifier.LAND || qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return {
        x: this.unfoldedWallpaperProp.contentScale,
        y: this.unfoldedWallpaperProp.contentScale,
        centerX: this.unfoldedWallpaperProp.pinchCenterX,
        centerY: this.unfoldedWallpaperProp.pinchCenterY,
      };
    }

    return {
      x: this.landWallpaperProp.contentScale,
      y: this.landWallpaperProp.contentScale,
      centerX: this.landWallpaperProp.pinchCenterX,
      centerY: this.landWallpaperProp.pinchCenterY,
    };
  }

  // instrument ignore next
  private async doSendData(): Promise<void> {
    Log.info(TAG, 'doSendData_back');
    try {
      this.checkIsAllowEnterFullScreenEditor = true;
      this.isBack = true;
      let isAllowEnterFullScreenEditor: boolean = await ThemeUtils.isAllowEnterFullScreenEditor();
      NavigationUtil.session?.sendData({
        'back': true,
        'enterFullScreen': isAllowEnterFullScreenEditor ? false : undefined,
      });
      if (isAllowEnterFullScreenEditor) {
        ThemeUtils.waitEnterFullScreenEditor(false);
      }
    } catch (err) {
      Log.error(TAG, `send Msg error: ${err?.code}`);
    }
  }

  private async onBackPressedChange(): Promise<void> {
    if (!this.isBack && await ThemeUtils.isAllowEnterFullScreenEditor()) {
      this.isBack = true;
      this.hasReturn = true;
      NavigationUtil.session?.sendData({
        'enterFullScreen': false,
      });
      ThemeUtils.waitEnterFullScreenEditor(false);
    }
  }

  // instrument ignore next
  onNavBackPress(): boolean {
    this.checkIsAllowEnterFullScreenEditor = true;
    clearTimeout(this.navBackTimer);
    if (this.exitClockFontAigc()) {
      return true;
    }
    if (this.clockWidgetEdit) {
      this.resetClockWidgetDefault();
      this.isHideBottomButton = false;
      return true;
    }
    this.backToPickerOrApp();
    return true;
  }

  private getLockConfigByQualifierWithCardIdCheck(qualifier: WallpaperQualifier): LockscreenConfig {
    const lockScreenConfig: LockscreenConfig = this.clockDataManager.getLockConfig(qualifier);
    // instrument ignore if
    if (!lockScreenConfig.form) {
      return lockScreenConfig;
    }
    const form: LockscreenForm = lockScreenConfig.form;
    form.list?.forEach((form: LockscreenFormConfig) => {
      const cardId: number | undefined = form.formInfo.cardId;
      if (cardId && cardId != 0) {
        Log.warn(TAG, `checkFormCardId, set ${cardId} to 0`);
        form.formInfo.cardId = 0;
      }
    });
    lockScreenConfig.form = form;
    return lockScreenConfig;
  }

  /**
   * 预览框应用，点击确定按钮
   */
  private onDetermineCallback(): void {
    Log.info(TAG, 'onDetermineCallback'); // 预览框应用按钮
    AppStorage.setOrCreate(AUTO_PICKER, false);
    PickerRecoveryController.clear(); // 壁纸选择并应用后，清除暂存的图库Picker现场信息
    HiTraceUtil.start(WALLPAPER_EDITOR_SET_WALLPAPER);
    this.isHideBottomButton = true;
    this.isHideTopButton = true;
    this.isLoading = true;
    this.isApplySheetShow = false;
    DialogUtil.closeDialog(this.getUIContext(), this.customDialogComponentId);
    this.loadingController?.open();
    this.applyWallpaper();
  }

  private onCancelCallback(): void {
    HiSysEventUtil.reportCancelApplyWallpaper(this.markWallpaperEntrance());
    this.isApplySheetShow = false;
    this.isHideBottomButton = false;
    DialogUtil.closeDialog(this.getUIContext(), this.customDialogComponentId);
  }

  @Builder
  ApplyDialogBuilder() {
    ApplyPreviewDialog({
      determineCallback: (selectedInfos: Map<WallpaperQualifier, SelectedInfo>) => {
        this.selectedInfos = selectedInfos;
        this.onDetermineCallback();
      },
      cancelCallback: () => {
        this.onCancelCallback();
      },
      qualifierSetting: this.qualifierSetting,
      selectedCallBack: this.selectedCallBack,
    }).onAppear(() => {
      this.isInProgress = false;
      ComStUtil.setWallpaperExtentionShow(true);
      this.snapshotPromise = this.loadPreviewsIfNecessaryEx();
    }).id('applySheetBuilder');
  }

  @Builder
  applySheetBuilder() {
    Column() {
      ApplySheet({
        unlockCameraImage: this.cameraMoverLockSnapShot,
        homeCameraImage: this.cameraMoverHomeSnapShot,
        isInProgress: this.isInProgress,
        isLoading: this.isLoading,
        isLockScreenSelected: $isLockScreenSelected,
        isHomeScreenSelected: $isHomeScreenSelected,
        isUnfoldLockSelected: $isLockScreenSelected,
        isUnfoldHomeSelected: $isHomeScreenSelected,
        isConnectWatch: this.isConnectWatch,
        isApplyWatch: this.isApplyWatch,
        isApplySubScreen: this.isApplySubScreen,
        callback: async () => {
          this.onDetermineCallback();
        },
        cancelCallback: () => {
          this.onCancelCallback();
        },
      })
        .width(undefined);
    }
    .size({
      width: this.applySheetWidth,
    })
    .onAppear(() => {
      Log.info(TAG, 'ApplySheet onAppear');
      this.isInProgress = false;
      if (this.usingCamMover()) {
        this.openCamMoverSheet();
      } else {
        this.snapshotPromise = this.loadPreviewsIfNecessary();
      }
    })
    .id('applySheetBuilder');
  }

  private generateWallpaperParams(): WallpaperInfoParams[] {
    let baseParams: WallpaperInfoParams = {
      isDof: true, // 多设备景深方案：无论最终景深是否显示，景深图都要存入主题包
      isLockSelected: this.isLockScreenSelected,
      isHomeSelected: this.isHomeScreenSelected,
      isHomeBlur: this.isDesktopBlur,
      applyFrom: this.params.imageAesthetic ? 'photo' : '',
    };
    let wallpaperInfoParams: WallpaperInfoParams[] = [baseParams];

    // instrument ignore else
    if (this.isBigFold) {
      let unfoldParams: WallpaperInfoParams = {
        isDof: true,
        isLockSelected: this.isLockScreenSelected,
        isHomeSelected: this.isHomeScreenSelected,
        isHomeBlur: this.isDesktopBlur,
        applyFrom: this.params.imageAesthetic || this.params.imageAestheticResult ? 'photo' : '',
      };
      wallpaperInfoParams.push(unfoldParams);
      let landParams: WallpaperInfoParams = {
        isDof: true,
        isLockSelected: this.isLockScreenSelected,
        isHomeSelected: this.isHomeScreenSelected,
        isHomeBlur: this.isDesktopBlur,
        applyFrom: this.params.imageAesthetic || this.params.imageAestheticResult ? 'photo' : '',
      };
      wallpaperInfoParams.push(landParams);
    }

    // instrument ignore if
    if (this.isPad) {
      let padLandParams: WallpaperInfoParams = {
        isDof: true,
        isLockSelected: this.isLockScreenSelected,
        isHomeSelected: this.isHomeScreenSelected,
        isHomeBlur: this.isDesktopBlur,
        applyFrom: this.params.imageAesthetic || this.params.imageAestheticResult ? 'photo' : '',
      };
      wallpaperInfoParams.push(padLandParams);
    }
    return wallpaperInfoParams; // 顺序需要与qualifiers数组一致
  }

  private changeStatusShowState(isFull: boolean): void {
    try {
      NavigationUtil.session?.sendData({ 'shouldShowStatus': !isFull });
    } catch (err) {
      Log.error(TAG, `changeStatusShowState, send Msg error: ${err?.code}`);
    }
  }

  private changeWindowMode(isFull: boolean): void {
    Log.info(TAG, `changeWindowMode isFull: ${isFull}`);
    try {
      this.changeStatusShowState(isFull);
    } catch (err) {
      Log.error(TAG, `changeWindowMode, send Msg error: ${(err as base.BusinessError).code}`);
    }
  }

  private applyThemeBack(): void {
    Log.info(TAG, 'applyThemeBack');
    NavigationUtil.doSetSystemBarColor('reset');
    HiTraceUtil.end(WALLPAPER_EDITOR_SET_WALLPAPER);
    if (this.wallpaperExternalHelper.isExternalScene()) {
      this.needFreeze = true;
      if (this.wallpaperExternalHelper.isThemeAppScene()) {
        this.changeWindowMode(false);
      }
      try {
        NavigationUtil.session?.sendData({ 'back': true, 'success': true, 'applyType': this.wallpaperApplyType });
      } catch (err) {
        Log.error(TAG, `send Msg error: ${err?.code}`);
      }
      return;
    }
    // instrument ignore if
    if (!this.isFromHomeOrLock && !this.isScreenLockKGSource()) {
      this.needFreeze = true;
      this.changeWindowMode(false);
      if (NavigationUtil.isNavToScreenlockEditor(this.bundleSource)) {
        NavigationUtil.doPageBack();
      } else if (DeviceHelper.isSettingSplitProduct()) {
        this.doSendData();
      } else {
        this.pageInfos.pop();
      }
      return;
    }
    NavigationUtil.doWallpaperApplyTheme();
  }

  changeSource(): void {
    CacheManger.editorParam().setSource(this.tabQualifier, this.source);
  }

  private resetClockWidgetDefault(): void {
    this.supportEdit = false;
    this.clockWidgetEdit = false;
    clearTimeout(this.resetClockEditTask);
    this.resetClockEditTask = setTimeout(() => {
      this.supportEdit = true;
    }, 50);
    Log.info(TAG, `reset clock WidgetDefault`);
  }
}
