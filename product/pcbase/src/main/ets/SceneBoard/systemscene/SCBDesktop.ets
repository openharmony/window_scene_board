/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Position } from '@kit.ArkUI';
import {
  LogDomain,
  Logger,
  DomainName,
  Trace,
  TraceUtil,
  CheckEmptyUtils,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { DropAnimationItem } from '@ohos/componentanimator/Index';
import {
  HiSysEventUtil,
  localEventManager,
  ResourceManager,
  viewMgrPolicy,
  ViewType,
  ViewArea,
  ViewCallback,
  EventManager,
  EvtBus,
  OobeActivatedEvent,
  DesktopItemsCountParams,
  DfxEvent,
  reportIntervalMgr,
  ReportParams,
  IconResourceManager,
  ViewManagerPolicy,
  GlobalContext,
  DeviceHelper,
  HiDfxEventUtil,
  TrimLevel
} from '@ohos/frameworkwrapper';
import {
  sSCBOobeManager,
  SCBScreenProperty,
  DisplayConstants,
  SCBPropertyChangeReason,
  SCBScreenSessionManager,
  SCBSceneSessionManager,
  SCBUnlockTransitionController,
  SCBTransitionManager,
  SCBSessionRect,
  SCBRotateChangeReason,
  ResUtils
} from '@ohos/windowscene';
import { ObjectCopyUtil, RTLUtil } from '@ohos/componenthelper';
import { PowerStatus } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  CommonConstants,
  EventConstants,
  UninstallDialogStatus,
  AppListInfo,
  FileType,
  keyEventManager,
  BaseConfig,
  PadLaunchLayoutCacheManager,
  FormCenterViewManager,
  LauncherLayoutCacheConfig,
  CalculateDesktopRst,
  LaunchLayoutCacheManager,
  KeyEventListener,
  BigFolderStyleConfig,
  FormEditViewManager,
  AppItemInfo,
  DesktopStatusBarHelper
} from '@ohos/launchercommon';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { FormComponentModel } from '@ohos/launchercommon/src/main/ets/form/model/FormComponentModel';
// import { CollaborationServiceStateDialog } from '@kit.ServiceCollaborationKit';
import { CollaborationDialogViewModel } from '../../common/viewmodel/CollaborationDialogViewModel'
import { LayoutViewModel } from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopLayout, RightMenuViewModel } from '@ohos/pagedesktop';
import StyleManager from '@ohos/form/src/main/ets/default/manager/StyleManager';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';
import { AppCenterGridStyleConfig } from '@ohos/appcenter';
import { FormStyleConfig } from '@ohos/form';
import { DeviceState } from '@ohos/launchercommon';
import { GridLayoutItemInfo, FormCenterLocation as FormCenterLocations } from '@ohos/launchercommon';
import { ThemeStyleCallback, ThemeStyleManager, ThemeStylePreviewManager } from '@ohos/launchercommon';
import { PageDesktopViewModel } from '@ohos/pagedesktop';
import { FormCenterView } from '@ohos/form/src/main/ets/formcenter/view/FormCenterView';
import settings from '@ohos.settings';
import { curves, display } from '@kit.ArkUI';
import common from '@ohos.app.ability.common';
import PowerStatusChangeAnimationController from '../scenemanager/PowerStatusChangeAnimationController';
import PcPageDesktopGridStyleConfig from '../../common/PcPageDesktopGridStyleConfig';
import { PcLayoutRulesController } from '../control/SceneDesktopController/PcLayoutRulesController';
import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import PcRightMenuViewModel from '../../common/viewmodel/PcRightMenuViewModel';
import { PcPageDesktopViewModel } from '../../common/viewmodel/PcPageDesktopViewModel';
import { PinExpiryNotificationController } from '../control/SceneDesktopController/PinExpiryNotificationController';
import { SCBSampleManager } from './SCBSampleManager';
import { HibernateDialog } from './HibernateDialog';
import lazy { PublishHibernateEvent } from '@ohos/batterycomponent/src/main/ets/pc/NotificationController';
import { KeyboardBatteryMgr } from '@ohos/statusbarcomponent/src/main/ets/common/KeyboardBatteryMgr';
import { PcNavigationItemStyle, PcNoResultStyle, PcSheetFormStyle } from './ViewModel/CardCenterStyle';
import { FormCenterStyleConfig } from '@ohos/form/src/main/ets/formcenter/viewstyles/manager/FormCenterStyleConfig';
import { FormCenterLocation } from '@ohos/form/src/main/ets/formcenter/viewstyles/manager/FormCenterEnum';
import { PcFormCenterViewStyle } from './ViewModel/PcFormCenterStyle';
import PcFileAccess from '../../common/controller/PcFileAccess';
import { FoldPcLayoutRulesController } from '../control/SceneDesktopController/FoldPcLayoutRulesController';
import { FoldSwiperController } from '../../common/FoldSwiperController';
import { DesktopModifier } from '../../ui/modifier/DesktopModifier';
import { SCBDesktopSelectionRect } from './SCBDesktopSelectionRect';
import { SCBSessionListManager} from '@ohos/pcmode';
import type ctx from '@ohos.app.ability.common';
import DesktopDrawDoneManager from '../../desktop/DesktopDrawDoneManager';
import { FirstUseKeyBoardWarningDialog } from '../keyboardWarningDialog/pages/FirstUseKeyBoardWarningDialog';
import { FirstUseKeyboardIntroductionDialog } from '../keyboardIntroDialog/pages/FirstUseKeyboardIntroductionDialog';
import { PreventPinchLegDialog } from '../keyboardIntroDialog/pages/PreventPinchLegDialog';
import { Constants } from '../keyboardWarningDialog/common/Constants';
import { PCUtils } from '../../common/utils/PCUtils';
import { StatusBarType } from '@ohos/systemuicommon';
import osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import PcLauncherLayoutStyleConfig from '../../common/PcLauncherLayoutStyleConfig';
import { DialogController, DialogControllerType } from '@ohos/launchercommon/src/main/ets/viewmodel/DialogController';
import { AppDialogController, FileFolderDialogController, FormDialogController } from './ViewModel/PcDialogController';
import RightMenuOptionsCalc from '../../common/viewmodel/RightMenuOptionsCalc';
import screenLockService from '../screenlock/refactor/ScreenLockService';
import { GridItemsPool } from '@ohos/pagedesktop/src/main/ets/default/manager/GridItemsPool';
import power from '@ohos.power';
import { FoldScreenReminder } from '../foldwarningtone/FlodWarningTone';
import { media } from '@kit.MediaKit';
import { SCBFoldPageSwitchIndicator } from './SCBFoldPageSwitchIndicator';
import { ActionType, KeyCode } from '@kit.InputKit';
import PcPresetStyleConstants from '../../common/constants/PcPresentConstants';
import { DesktopLayoutManager } from '@ohos/pagedesktop/src/main/ets/default/manager/DesktopLayoutManager';
import { PcDesktopLayoutManager } from './ViewModel/PcDesktopLayoutManager';
import { PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import { SCBDesktopDebugCommand } from './debug/SCBDesktopDebugCommand';
import { KnockShareManager } from './KnockShare';
import { SingleDialogController } from './SingleDialogController';
import { GravityAnimationConfig } from '@ohos/componentanimator/Index';
import { DesktopSettingUtils } from '@ohos/launchercommon/Index';
import { fileFolderManagerFactory } from '@ohos/desktopfilefolder';
import { FormEditViewProxy } from './form/FormEditViewProxy';
import { FormEditSecViewProxy } from './form/FormEditSecViewProxy';
import { FormEditLayout } from './form/FormEditLayout';
import { FormCenterManager } from './manager/FormCenterManager';

const TAG = 'SCBDesktop';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const FOCUS_CHANGE_INTERVAL: number = 200;
const NOTIFICATION_PUBLISH_INTERVAL: number = 500;
const SCREENOFF_AC_TIMEOUT_KEY: string = 'settings.display.ac.screen_off_timeout';
const SCREENOFF_DC_TIMEOUT_KEY: string = 'settings.display.dc.screen_off_timeout';
const IDLE_DEFAULT_AC_VALUE: string = '600000'; // 600000对应10分钟，为电源供电时无操作熄屏默认时间
const IDLE_DEFAULT_DC_VALUE: string = '300000'; // 300000对应5分钟，为电池供电时无操作熄屏默认时间
const IDLE_VALUE_30S: string = '30000'; // 30000对应30s
const SUSPEND_AC_SOURCES_KEY: string = 'settings.power.ac.suspend_sources';
const SUSPEND_AC_SOURCES_DEFAULT: string = `{"powerkey":{"action":2,"delayMs":0},"timeout":{"action":1,"delayMs":0},"lid":{"action":1,"delayMs":0},"switch":{"action":2,"delayMs":0}}`; // ac电源设置项默认值
const AC_SWITCH_SETTING_DEFAULT: number = 2; // 接通电源时合盖设置项默认值
const AC_SWITCH_SETTING_ZERO: number = 0; // 接通电源时合盖不作任何操作
const FOLD_ANGLE_65: number = 65; // 折叠角度65
const FOLD_ANGLE_50: number = 50; // 折叠角度50
const FOLD_ANGLE_5: number = 5; // 折叠角度5
const FOLD_ANGLE_180: number = 180; // 折叠角度180,用于初始化
const FOLD_ANGLE_132: number = 132; // 折叠角度132
const FOLD_ANGLE_130: number = 130; // 折叠角度130
const DEBOUNCE_ANGLE: number = 5; // 防抖度数
const QUARTER_OF_SCREEN = 4; // 用于获取四分之一的屏幕高度
const GRAVITY_ANIMATION_PARAMETER = 'pc_gravity_animation_parameter.json'; // PC的引力动效配置
PersistentStorage.persistProp('firstUseKeyBoard', true);

@Component
export struct SCBDesktop {
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') @Watch('updateScreenInfo') screenHeight: number = 0;
  @StorageLink('deviceType') deviceType: string = CommonConstants.DEFAULT_DEVICE_TYPE;
  @StorageLink('pinValidityPeriod') pinValidityPeriod: number = 0;
  @State workSpaceWidth: number = 0;
  @State workSpaceHeight: number = 0;
  private isExpandStatus: boolean = false;
  @State dockHeight: number = 0;
  private mLayoutViewModel: LayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig =
    PcPageDesktopGridStyleConfig.getInstance(this.singleContext);
  private drawDoneManager: DesktopDrawDoneManager = new DesktopDrawDoneManager(`${TAG}_Image_container`);
  private navigationBarStatus: string | undefined = '0';
  @State viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP);
  @State shutdownViewController: BaseViewController = new BaseViewController(ViewType.SHUTDOWN_VIEW);
  persistentId : number = 0;
  @State scaleValue: number = 1;
  @State opacityValue: number = 1;
  @State hibernateDialogOffsetY: number = 0;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @Provide isShowingUninstallDialog: number = UninstallDialogStatus.INITIAL_STATE;
  @Provide dragToUninstallItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @Provide('clearDesktopMemory') clearDesktopMemory: boolean = false;
  @Provide('releaseDesktopMemory') releaseDesktopMemory: boolean = false;
  @Provide('convertFolderId') convertFolderId : string = '-1';
  @Provide('isFromDock') isFromDock: boolean = false;
  @Provide isDesktopEnabled: boolean = true;
  @Provide('globalSearchTranslateY') globalSearchTranslateY: number = 0;
  @StorageLink('activeSceneNum') activeSceneNum: number = 0;
  private isKeyBoardStatus: boolean = false;
  @State isIndicatorShow: number = 0;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private appListInfo: AppListInfo = new AppListInfo();
  private rightMenuOptionsCalc = new RightMenuOptionsCalc();
  private rightMenuViewModel: PcRightMenuViewModel =
    singleManager.get<PcRightMenuViewModel>(PcRightMenuViewModel, this.singleContext);
  private collaborationDialogModel: CollaborationDialogViewModel = new CollaborationDialogViewModel(this.singleContext);
  private layoutRulerController: PcLayoutRulesController | undefined = this.getLayoutRulerController();
  private foldSwiperController: FoldSwiperController = FoldSwiperController.getInstance(this.singleContext);
  private fileOpDialogController: CustomDialogController | undefined = undefined;
  private waitingForUnlock: boolean = false;
  private isTopFullOrSplit: boolean = false;
  private isFirstBoot: boolean = true;
  private isPortrait: boolean = true;
  // 是否首次绘制完成
  private firstDrawDone: boolean = false;
  private drawDownUnderOobe: boolean = false;
  private currScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  private desktopFocused: boolean = false;
  private mFoldCreaseRegionHeight = 0;
  private mFoldAngle: number = FOLD_ANGLE_180;
  private isKbdAttached: boolean = false;
  private isFirstPlayWhenScreenOff = true;
  private isAngleChangeRegistered = false;
  private isShowKeyboardWarningDialog = false;
  // 防夹腿弹框提示
  private isShowPreventPinchLegDialog: boolean = false;
  private isNeedPreventPinchLegDialog: boolean = true; //底层每100毫秒上传一次角度变化，因此需要判断哪些场景需要显示防夹腿弹框
  private closeDialogCount: number = 0;
  private isIgnoreDebounce: boolean = true;
  // 设置中修改字体大小
  @StorageProp('fontSizeScale') @Watch('fontSizeScaleChange') fontSizeScale: number = 1;
  private fontSizeScaleTimeId: number = CommonConstants.INVALID_VALUE;

  modifier: DesktopModifier = new DesktopModifier();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: HibernateDialog({ offsetY: this.hibernateDialogOffsetY }),
    showInSubWindow: true,
    customStyle: true,
    autoCancel: false,
    maskColor: Color.Transparent,
  });
  private keyBoardIntroductionDialog: SingleDialogController =
    new SingleDialogController('keyBoardIntroductionDialog', new CustomDialogController({
    builder: FirstUseKeyboardIntroductionDialog({
      close: () => {
        this.keyBoardIntroductionDialog.close();
      }
    }),
    alignment: DialogAlignment.Top,
    autoCancel: false,
    showInSubWindow: true,
    shadow: ShadowStyle.OUTER_FLOATING_MD,
    openAnimation: { delay: 100 },
    closeAnimation: { duration: 150 },
    maskColor: Color.Transparent,
    offset: {
      dx: Constants.DEFAULT_NUMBER_0,
      dy: Constants.OFFSET_DY
    }
  }));
  private keyBoardWarningDialog: SingleDialogController =
    new SingleDialogController('keyBoardWarningDialog', new CustomDialogController({
    builder: FirstUseKeyBoardWarningDialog({
      close: () => {
        this.keyBoardWarningDialog.close();
      }
    }),
    alignment: DialogAlignment.Top,
    openAnimation: { curve: curves.springCurve(0, 1, 200, 22), delay: 100 },
    closeAnimation: { duration: 150 },
    maskColor: Color.Transparent,
    autoCancel: false,
    showInSubWindow: true,
    shadow: ShadowStyle.OUTER_FLOATING_MD,
    offset: {
      dx: Constants.DEFAULT_NUMBER_0,
      dy: Constants.OFFSET_DY
    },
  }));
  private preventPinchLegDialog: CustomDialogController | undefined = undefined;
  @State isRotating: boolean = false;
  @State rotateImg: image.PixelMap | undefined = undefined;
  @State rotateImgOpa: number = 0;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_SCBDesktop`,
    onLock: (): void => this.onLockReceived(),
    onUnlock: (): void => this.onUnLockReceived()
  };

  // Used for shutdown animation
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;

  private escKeyEventListener: KeyEventListener = {
    onReceiveKeyEvent: (event: string) => {
      if (!PageDesktopViewModel.getInstance().hasCutItems()) {
        log.showInfo(TAG, 'no cut items need to clear pasteboard');
        return;
      }
      fileFolderManagerFactory.getFileFolderManager().clearPasteboard();
    }
  }

  /**
   * 设置中修改字体大小，先关闭节点组缓存，2秒后开启
   */
  private fontSizeScaleChange(): void {
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, false);
    if (this.fontSizeScaleTimeId !== CommonConstants.INVALID_VALUE) {
      clearTimeout(this.fontSizeScaleTimeId);
    }
    this.fontSizeScaleTimeId = setTimeout(() => {
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, true);
    }, 2000);
  }

  private getFormCenterPosition: Callback<FormCenterLocations | undefined, Position> = (formCenterLocation?: FormCenterLocations) => {
    PageDesktopViewModel.getInstance(this.singleContext).setTargetIndex(0);
    return FormCenterManager.getInstance().getFormCenterPosition(formCenterLocation);
  }

  private closeFormCenter(): void {
    const formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    if (!formCenterViewManager.isFormCenterViewShowing()) {
      return;
    }
    // 设备发生形变时均自动退出
    formCenterViewManager.closeFormCenterView();
  }

  private virtualKeyboardChangeCallback: Callback<void> = () => {
  }

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      this.scaleValue = PowerStatusChangeAnimationController.DEFAULT_SCALE_RATIO;
      this.opacityValue = PowerStatusChangeAnimationController.DEFAULT_OPACITY_RATIO;
      log.showInfo(TAG,`scaleValue onPowerStatusChange to ${this.scaleValue}`);
      return;
    }
    PowerStatusChangeAnimationController.closeDeskTop(() => {
      this.closeDeskTopCallback();
    });
  }

  private setLayoutRulerControllerOren(isPortrait: boolean, callerTag?: string): void {
    log.showInfo(TAG, `setLayoutRulerControllerOren: isPortrait ${isPortrait}, tag: ${callerTag}`);
    if (this.layoutRulerController instanceof FoldPcLayoutRulesController) {
      (this.layoutRulerController as FoldPcLayoutRulesController).setIsPortrait(isPortrait);
    }
  }

  onLock() {
    // Do not handle when oobe is enabled
    log.showInfo(TAG, 'onLock, isLock: %{public}s', this.isLock);
    if (sSCBOobeManager.isOobeActivated()) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, !this.isLock);
      log.showWarn(TAG, 'OOBE is activated, cant process event');
      return;
    }

    if (this.isLock) {
      log.showInfo(TAG,
        'onLock getWindowSize px2vp: %{public}d, screenWidth: %{public}d, screenHeight: %{public}d, screenId: %{public}d',
        px2vp(1), this.screenWidth, this.screenHeight, this.screenProp?.screenId);
      this.lockDeskTopCallback();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, false);
      AppStorage.setOrCreate('lockReceived', Date.now());
    } else {
      if (this.scaleValue !== 1) {
        animateTo({ duration: 200 }, () => {
          this.scaleValue = 1;
        })
      }
      log.showInfo(TAG, TraceUtil.CORE_METHOD_INTO_LAUNCHER);
      TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_INTO_LAUNCHER);
      HiSysEventUtil.reportUnlockEnterDesktop(HiSysEventUtil.INTO_HOME_KEY, 0);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
      // pin码超期提醒
      setTimeout(() => {
        PinExpiryNotificationController.getInstance().publishNotification(this.pinValidityPeriod);
      }, NOTIFICATION_PUBLISH_INTERVAL);
    }
  }

  private readonly desktopItemsCountEvent: DfxEvent = {
    report: () : void => {
      let getDesktopItemsCount: DesktopItemsCountParams = this.desktopItemsCount();
      log.showInfo(TAG, 'desktopItemsCountEvent report happened');
      HiSysEventUtil.reportDesktopItemsCount(getDesktopItemsCount);
    }
  }

  private updateHibernateDialogOffsetY(): void {
    this.hibernateDialogOffsetY = 0;
  }

  private hibernateControllerOpen = (event: PublishHibernateEvent): void => {
    if (event.state === true) {
      if (!DeviceHelper.isPcNot2in1Device()) {
        log.showInfo(TAG, 'hibernateControllerOpen 2in1 not show hibernate dialog');
        return;
      }
      if (!screenLockService.isScreenOn) {
        log.showInfo(TAG, 'hibernateControllerOpen screen off not to hibernate');
        return;
      }
      log.showInfo(TAG, 'hibernateControllerOpen start');
      this.updateHibernateDialogOffsetY();
      let osAccountManager: osAccount.AccountManager = osAccount.getAccountManager();
      if (!osAccountManager) {
        log.showInfo(TAG, 'hibernateControllerOpen osAccountManager is null');
        this.dialogController.open();
        return;
      }
      osAccountManager.getOsAccountLocalId().then((currentId: number) => { // 获取当前进程的用户id
        log.showInfo(TAG, 'hibernateControllerOpen getOsAccountLocalId');
        osAccountManager.getForegroundOsAccountLocalId().then((currentForegroundId: number) => { // 获取前台用户id
          log.showInfo(TAG, 'hibernateControllerOpen getForegroundOsAccountLocalId');
          if (currentId === currentForegroundId) {
            log.showInfo(TAG, 'hibernateControllerOpen current is foreground');
            this.dialogController.open();
          }
        }).catch((err: BusinessError) => {
          log.showError(TAG, `hibernateControllerOpen getForegroundOsAccountLocalId failed, code: ${err?.code}, message: ${err?.message}`);
        });
      }).catch((err: BusinessError) => {
        log.showError(TAG, `hibernateControllerOpen getOsAccountLocalId failed, code: ${err?.code}, message: ${err?.message}`);
      });
    }
  }

  private initRightMenuViewModel(): void {
    this.updateFoldScreenRect(this.rightMenuOptionsCalc);
    this.rightMenuViewModel.setRightMenuOptionsCalc(this.rightMenuOptionsCalc);
  }

  private updateFoldScreenRect(rightMenuOptionsCalc: RightMenuOptionsCalc): void {
    const screenRect: SCBSessionRect =
      new SCBSessionRect(this.screenProp.left, this.screenProp.top, this.screenProp.width, this.screenProp.height);
    rightMenuOptionsCalc.updateScreenRect(screenRect, undefined);
  }

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear');
    DesktopLayoutManager.setDesktopLayoutManager(new PcDesktopLayoutManager());
    SCBSampleManager.getInstance().registerKeyObserverSample();
    PageDesktopViewModel.getInstance(this.singleContext)?.voteBootEvent();
    PageDesktopViewModel.getInstance(this.singleContext)?.setIsSupportLayoutAndDockSameIcon(true);
    log.showInfo(TAG, 'boot vote finished');
    AppStorage.setOrCreate<number>('folderStatus', DeviceState.DEFAULT_STATE);
    viewMgrPolicy.registerViewController(ViewType.DESKTOP, this.viewController);
    viewMgrPolicy.registerViewController(ViewType.SHUTDOWN_VIEW, this.shutdownViewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.eventMgr.on(OobeActivatedEvent, this.onOobeChangeEvent);
    this.eventMgr.on(PublishHibernateEvent, this.hibernateControllerOpen);

    // init layout config
    this.mLayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
    let baseConfig = this.mLayoutViewModel.getBaseConfig();
    this.layoutRulerController = this.getLayoutRulerController(baseConfig);
    this.setLayoutRulerControllerOren(this.isPortrait);
    this.mLayoutViewModel.setLayoutRulesController(this.layoutRulerController);
    this.foldSwiperController.setDesktopModifier(this.modifier);
    this.getWindowSize(this.screenProp, 'aboutToAppear');
    this.updateScreenSize('aboutToAppear');
    AppStorage.setOrCreate<boolean>('isPortrait', this.isPortrait);
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopClearCallback);
    this.registerPageDesktopNavigatorStatusChangeEvent(this.mLocalEventListener);

    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.screenRotateChangeCallBack,
      this.screenProp?.screenId);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
    /*LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.DESKTOP_CALLBACK,
      () => {
        this.scaleValue = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
        log.showInfo(TAG, `scaleValue LockScreenAnimationController to ${this.scaleValue}`);
      }, () => {
        HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_GRID_ANIMATION_END, 0);
      });*/
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    ThemeStyleManager.getInstance().registerThemeEvent(this.themeEventCallBack);
    ThemeStyleManager.getInstance().registerThemeCallBack(this.themeStyleCallback);
    viewMgrPolicy.registerViewCallback('SCBThemeEditor', this.themeEditViewCallback);
    reportIntervalMgr.registerEvent(this.desktopItemsCountEvent);
    this.initIconChange();
    this.initPowerSettings();
    this.initFormCenter();
    this.initRightMenuViewModel();
    this.getContext()?.eventHub.on('WindowStyleChange',
      this.flushDockStyle);
    GlobalContext.getContext()?.eventHub.on('changeDesktopOpacity', this.changeOpacity);
    SCBDesktopDebugCommand.getInstance().register();
    this.initDialog();
    FoldScreenReminder.getInstance().createAudioPlayer();
    KnockShareManager.getInstance().enableKnockShare(this.persistentId);
    KnockShareManager.getInstance().enableKnockReceive(this.persistentId);
    this.registerFoldAngleChangeEvent();
    this.createPreventPinchLegDialog();
    GravityAnimationConfig.reloadConfigs(GRAVITY_ANIMATION_PARAMETER);
    keyEventManager.registerKeyEventListener(this.escKeyEventListener, [KeyCode.KEYCODE_ESCAPE.toString()]);
    if (DeviceHelper.is2In1DevicePcType()) {
      DesktopSettingUtils.disableDesktopSettingsSearchItems();
    }
    FormEditViewManager.getInstance().isSheetEditView = false;
    FormEditViewProxy.getInstance().init(this.getUIContext());
    FormEditSecViewProxy.getInstance().init();
  }

  changeOpacity = (opacityValue: number) => {
    log.showInfo(TAG, 'changeOpacity opacity = %{public}d', opacityValue);
    if (opacityValue === 0) {
      ViewManagerPolicy.hideView(ViewType.DESKTOP);
    } else {
      ViewManagerPolicy.showView(ViewType.DESKTOP);
    }
  }

  private initFormCenter(): void {
    FormCenterStyleConfig.getInstance().setStyle(FormCenterLocation.DESKTOP, new PcFormCenterViewStyle());
    StyleManager.setGridStyle(true);
    StyleManager.setNavigationItemStyle(new PcNavigationItemStyle());
    StyleManager.setSheetFormStyle(new PcSheetFormStyle());
    StyleManager.setNoResultStyle(new PcNoResultStyle());
    FormCenterManager.getInstance().init(this.getUIContext());
    FormCenterViewManager.getInstance().setCalculateFormCenterPosition(this.getFormCenterPosition);
    FormCenterViewManager.getInstance().setEntrancePosCallback(
      (layoutInfo?: AppItemInfo | GridLayoutItemInfo, position?: Position) => {
      return FormCenterManager.getInstance().getFormCenterEnterLocation(layoutInfo, position);
    });
  }

  private screenPropertyChangeCallBack = (screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason) => {
    if (!screenProperty) {
      log.showWarn(TAG, 'screenProperty is null');
      return;
    }
    let area: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(screenProperty.width),
      height: px2vp(screenProperty.height)
    }
    if (screenProperty.screenId === 0 && this.isRotating && !this.isTopFullOrSplit) {
      log.showWarn(TAG, 'screenPropertyChangeCallBack is rotating main screen!');
      this.viewController.updateRect(area);
      log.showInfo(TAG, 'screen property change  width = %{public}d, height = %{public}d, reason = %{public}d',
        area.width, area.height, reason);
      return;
    }
    if (!this.firstDrawDone &&
      (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION)) {
      log.showInfo(TAG, 'screenPropertyChangeCallBack, desktop has not draw done');
      this.currScreenProperty = screenProperty;
      return;
    }
    log.showInfo(TAG, 'screen property change  width = %{public}d, height = %{public}d, reason = %{public}d',
      area.width, area.height, reason);
    this.viewController.updateRect(area);
    this.getWindowSize(screenProperty, 'screenPropertyChangeCallBack');
    switch (reason) {
      // undefined是不带行为的回调
      case SCBPropertyChangeReason.UNDEFINED:
        break;
      case SCBPropertyChangeReason.CHANGE_MODE:
        this.workSpaceHeight = screenProperty.height - this.mLayoutViewModel.getSysUITopHeight() -
        vp2px(PcSmartDockStyleManager.getStyle(screenProperty).mDockHeight);
        (this.getContext() as
        common.ServiceExtensionContext)?.eventHub.emit(EventConstants.EVENT_SCREEN_ID_CHANGE);
        PcPageDesktopViewModel.getInstance().placeGridLayoutItems();
        break;
      case SCBPropertyChangeReason.ROTATION:
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
        this.changeGridLayout(this.screenProp);
        break;
      default:
        break;
    }
    log.showInfo(TAG, 'screenPropertyChangeCallBack end');
  }

  private screenRotateChangeCallBack = (screenProperty: SCBScreenProperty,
    reason: SCBRotateChangeReason) => {
    log.showWarn(TAG, 'screenRotateChangeCallBack reason = %{public}d', reason);
    FormComponentModel.getInstance()
      .setIsScreenRotateAni(reason === SCBRotateChangeReason.ROTATE_BEGIN);
    if (!screenProperty) {
      log.showWarn(TAG, 'screenRotateChangeCallBack is null');
      return;
    }
    this.currScreenProperty = screenProperty;
    if (!this.firstDrawDone) {
      log.showWarn(TAG, 'screenRotateCallBack, desktop has not draw done');
      return;
    }
    switch (reason) {
      case SCBRotateChangeReason.ROTATE_BEGIN:
        if (this.isLock) {
          this.viewController?.hide();
        }
        GridItemsPool.getInstance().setIsRelease(false);
        this.isRotating = true;
        this.checkTopOrSplit();
        if (this.isTopFullOrSplit) {
          log.showWarn(TAG, 'screenRotateChangeCallBack isTopFullOrSplit');
          return;
        }
        this.getRotateSnapshot(screenProperty);
        break;
      case SCBRotateChangeReason.ROTATE_END:
        if (this.isLock && !this.viewController?.isShowing()) {
          this.viewController?.show();
        }
        GridItemsPool.getInstance().setIsRelease(true);
        this.isRotating = false;
        this.rotateImg?.release();
        this.rotateImgOpa = 0;
        let area: ViewArea = {
          left: 0,
          top: 0,
          width: screenProperty.width,
          height: screenProperty.height
        }
        this.viewController.updateRectInPx(area);
        break;
      default:
        break;
    }
    log.showInfo(TAG, 'screenRotateCallBack end');
  }

  private checkTopOrSplit(): void {
    const containerSessionList = SCBSessionListManager.getNormalContainerArray(this.screenProp);
    this.isTopFullOrSplit = false;
  }

  private getRotateSnapshot(screenProperty: SCBScreenProperty): void {
    try {
      let img: image.PixelMap | undefined = componentSnapshot.getSync(`${TAG}_layout_container`, { scale: 0.25 });
      if (img) {
        this.rotateImg = img;
        this.rotateImgOpa = 1;
        this.opacityValue = 0;
        log.showInfo(TAG, 'componentSnapshot success');
      } else {
        log.showError(TAG, 'componentSnapshot fail');
      }
    } catch (err) {
      log.showError(TAG, `componentSnapshot failed, with reason ${err?.code} ${err?.message}`);
    }
    this.getWindowSize(screenProperty, 'rotateImg');
    this.changeGridLayout(screenProperty);
  }

  /**
   * 横竖屏旋转，更新桌面布局及元素
   * @param screenProp
   */
  private changeGridLayout(screenProp: SCBScreenProperty): void {
    const curScreenVertical: boolean = this.getPortrait(screenProp.screenId);
    log.showInfo(TAG, `changeGridLayout, curScreenVertical: ${curScreenVertical}, isPortrait: ${this.isPortrait}`);
    if (curScreenVertical !== this.isPortrait || this.isFirstBoot) {
      log.showInfo(TAG, `changeGridLayout screen rotated isFirstBoot: ${this.isFirstBoot}`);
      this.isPortrait = curScreenVertical;
      this.rotationForLayoutCache();
      if (this.isFirstBoot) {
        AppStorage.setOrCreate<boolean>('isPortrait', false);
        this.isFirstBoot = false;
      }
      AppStorage.setOrCreate<boolean>('isPortrait', curScreenVertical);
    }
  }

  private rotationForLayoutCache(): void {
    log.showInfo(TAG, 'rotationForLayoutCache');
    try {
      const cacheManager: LaunchLayoutCacheManager = LauncherLayoutCacheConfig.getInstance().getLayoutCacheManager();
      const legalInstance: boolean = cacheManager instanceof PadLaunchLayoutCacheManager;
      log.showError(TAG, `legalInstance:${legalInstance}`);
    } catch (error) {
      log.showError(TAG, `rotationForLayoutCache error ${error?.code}, ${error?.message}`);
    }
  }

  private oobeStateEndCallback = () => {
    this.stateChangeOnOObeEnd();
  }

  private controlPreventPinchLegDialog(curAngle: number) {
    // 设置往回折叠防抖角度为DEBOUNCE_ANGLE
    if (curAngle < (FOLD_ANGLE_132 - DEBOUNCE_ANGLE) && !this.isIgnoreDebounce) {
      this.isIgnoreDebounce = true;
    }
    //折叠角度>132度时显示防夹肉弹框
    if (curAngle > FOLD_ANGLE_132 && this.isNeedPreventPinchLegDialog && this.isIgnoreDebounce) {
      // 不再提示
      if (PreventPinchLegDialog.isDoNotRemind) {
        return;
      }
      // 弹框已显示
      if (this.isShowPreventPinchLegDialog) {
        return;
      }
      // 开机和重启展开态不弹框
      if (this.isExpandStatus) {
        return;
      }
      // OOBE阶段不弹框
      if (sSCBOobeManager.isOobeActivated()) {
        return;
      }
      // 锁屏态不弹框
      if (this.isLock) {
        return;
      }
      log.showInfo(TAG, 'showPreventPinchLegDialog');
      this.isShowPreventPinchLegDialog = true;
      this.preventPinchLegDialog?.open();
      this.isIgnoreDebounce = false;
    }
    if (curAngle < FOLD_ANGLE_130) {
      // 为了下次折叠角度>132度时重启打开防夹肉弹框
      if (!this.isShowPreventPinchLegDialog && !this.isNeedPreventPinchLegDialog) {
        this.isNeedPreventPinchLegDialog = true;
      }
      //键盘吸附状态，折叠角度<130度时关闭防夹肉弹框
      if (this.isKbdAttached && this.isShowPreventPinchLegDialog) {
        log.showInfo(TAG, 'closePreventPinchLegDialog');
        this.preventPinchLegDialog?.close();
        this.isShowPreventPinchLegDialog = false;
        this.isNeedPreventPinchLegDialog = true;
      }
    }
    //折叠角度>130度时关闭键盘下压弹框
    if (curAngle > FOLD_ANGLE_130) {
      this.closeKeyboardDialog();
    }
  }

  private onFoldAngleChange: (angles: number[]) => void = (angles: number[]): void => {
    if (angles === undefined || angles.length <= 0) {
      log.showError(TAG, 'angles array error');
      return;
    }
    this.handleFoldAngleChange(angles[0]);
    this.controlPreventPinchLegDialog(angles[0]);
  };

  /**
   * 接收键盘吸附状态，吸附时拉起弹框，分离时取消弹框
   * 合盖角度小于75时，播放警示音
   * @param isAttached
   */
  private handleKeyboardAdsorptionChange(isAttached: boolean): void {
    this.isKbdAttached = isAttached;
    if (!isAttached) {
      this.closeKeyboardDialog();
      this.isShowKeyboardWarningDialog = false;
      FoldScreenReminder.getInstance().enableAudioPlayer(false, undefined);
      return;
    }

    if (this.mFoldAngle > FOLD_ANGLE_65 && isAttached) {
      FoldScreenReminder.getInstance().enableAudioPlayer(false, undefined);
      this.openKeyboardDialog();
      return;
    }
    if (this.mFoldAngle <= FOLD_ANGLE_65 && this.mFoldAngle > FOLD_ANGLE_50) {
      this.openKeyboardWarningToneAndDialog(media.PlaybackSpeed.SPEED_FORWARD_1_50_X);
    } else if (this.mFoldAngle <= FOLD_ANGLE_50 && this.mFoldAngle > FOLD_ANGLE_5) {
      this.openKeyboardWarningToneAndDialog(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
    } else if (this.mFoldAngle <= FOLD_ANGLE_5) {
      FoldScreenReminder.getInstance().enableAudioPlayer(false, undefined);
    } else {
      log.showDebug(TAG, `angle error: ${this.mFoldAngle}`);
    }
  }

  private handleFoldAngleChange(curAngle: number): void {
    log.showDebug(TAG, `handleFoldAngleChange angles:${curAngle}`);

    this.mFoldAngle = curAngle;

    if (curAngle > FOLD_ANGLE_65 || !this.isKbdAttached) {
      this.isShowKeyboardWarningDialog = false;
      this.isFirstPlayWhenScreenOff = true;
      FoldScreenReminder.getInstance().enableAudioPlayer(false, undefined);
      return;
    }

    if (this.mFoldAngle <= FOLD_ANGLE_65 && this.mFoldAngle > FOLD_ANGLE_50 &&
      !FoldScreenReminder.getInstance().isWarningTonePlaying(media.PlaybackSpeed.SPEED_FORWARD_1_50_X)) {
      this.openKeyboardWarningToneAndDialog(media.PlaybackSpeed.SPEED_FORWARD_1_50_X);
    } else if (!FoldScreenReminder.getInstance().isWarningTonePlaying(media.PlaybackSpeed.SPEED_FORWARD_2_00_X) &&
      this.mFoldAngle <= FOLD_ANGLE_50 && this.mFoldAngle > FOLD_ANGLE_5) {
      this.openKeyboardWarningToneAndDialog(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
    } else if (this.mFoldAngle <= FOLD_ANGLE_5) {
      FoldScreenReminder.getInstance().enableAudioPlayer(false, undefined);
    } else {
      log.showDebug(TAG, 'duplicate operation');
      return;
    }
  }

  private openKeyboardWarningToneAndDialog(speed: media.PlaybackSpeed): void {
    if (this.mFoldAngle > FOLD_ANGLE_65 || !this.isKbdAttached) {
      return;
    }
    this.closeKeyBoardIntroductionDialog();
    if (this.isLock) {
      log.showDebug(TAG, 'openKeyboardWarningToneAndDialog: screen is locked');
      this.waitingForUnlock = true;
    } else if (!this.isShowKeyboardWarningDialog) {
      log.showInfo(TAG, 'openKeyboardWarningToneAndDialog: open keyBoardWarningDialog');
      this.openKeyboardWarningDialog();
    }
    this.isShowKeyboardWarningDialog = true;

    if (screenLockService.isScreenOn) {
      this.isFirstPlayWhenScreenOff = true;
    } else {
      if (!this.isFirstPlayWhenScreenOff) {
        return;
      }
      this.isFirstPlayWhenScreenOff = false;
    }

    log.showInfo(TAG, `WarningTone angles:${this.mFoldAngle}`);
    FoldScreenReminder.getInstance().enableAudioPlayer(true, speed);
  }

  private openKeyboardDialog(): void {
    log.showInfo(TAG, 'keyboard is placed');
    if (this.isLock) {
      this.waitingForUnlock = true;
      return;
    }

    if (!KeyboardBatteryMgr.getInstance().getKeyboardConnectStatus()) {
      log.showInfo(TAG, 'keyboard Introduction Dialog opened');
      this.openKeyboardIntroductionDialog();
    } else {
      log.showInfo(TAG, 'keyboard warning Dialog opened');
      this.openKeyboardWarningDialog();
    }

  }

  private createPreventPinchLegDialog(): void {
    this.preventPinchLegDialog = new CustomDialogController({
      builder: PreventPinchLegDialog({
        closeDialogCount: this.closeDialogCount,
        close: () => {
          this.isShowPreventPinchLegDialog = false;
          if (this.mFoldAngle > FOLD_ANGLE_132) {
            this.isNeedPreventPinchLegDialog = false;
          } else {
            this.isNeedPreventPinchLegDialog = true;
          }
          this.closeDialogCount = this.closeDialogCount + 1;
          this.preventPinchLegDialog?.close();
          log.showInfo(TAG, `closeDialogCount ${this.closeDialogCount}`);
        }
      }),
      alignment: DialogAlignment.Top,
      autoCancel: false,
      showInSubWindow: true,
      openAnimation: { delay: 100 },
      closeAnimation: { duration: 150 },
      maskColor: Color.Transparent,
      offset: {
        dx: Constants.DEFAULT_NUMBER_0,
        dy: Constants.OFFSET_DY
      }
    })
  }

  private openKeyboardIntroductionDialog(): void {
    if (this.mFoldAngle > FOLD_ANGLE_130) {
      log.showInfo(TAG, 'FoldAngle Over 130');
      return;
    }
    this.closeKeyBoardWarningDialog();
    this.keyBoardIntroductionDialog.open();
  }

  private openKeyboardWarningDialog(): void {
    if (this.mFoldAngle > FOLD_ANGLE_130) {
      log.showInfo(TAG, 'FoldAngle Over 130');
      return;
    }
    this.closeKeyBoardIntroductionDialog();
    this.keyBoardWarningDialog.open();
  }

  private closeKeyboardDialog(): void {
    this.closeKeyBoardIntroductionDialog();
    this.closeKeyBoardWarningDialog();
    this.waitingForUnlock = false;
  }

  private closeKeyBoardIntroductionDialog(): void {
    this.keyBoardIntroductionDialog.close();
  }

  private closeKeyBoardWarningDialog(): void {
    this.keyBoardWarningDialog.close();
    this.waitingForUnlock = false;
  }

  private onLockReceived(): void {
    log.showInfo(TAG, 'lock received');
  }

  private onUnLockReceived() {
    log.showInfo(TAG, 'unlock received');
    if (!this.viewController?.isShowing()) {
      this.viewController?.show();
    }
    if (this.waitingForUnlock === true) {
      if (this.mFoldAngle <= FOLD_ANGLE_65 && this.isKbdAttached) {
        log.showInfo(TAG, 'keyboard warning Dialog fold angle <= 75');
        this.openKeyboardWarningDialog();
      } else if (!KeyboardBatteryMgr.getInstance().getKeyboardConnectStatus()) {
        log.showInfo(TAG, 'keyboard Introduction Dialog opened on unlock');
        this.openKeyboardIntroductionDialog();
      } else {
        log.showInfo(TAG, 'keyboard warning Dialog opened on unlock');
        this.openKeyboardWarningDialog();
      }
    }
    this.waitingForUnlock = false;
  }

  private updateScreenOrientation(isPortrait: boolean): void {
    log.showInfo(TAG, `updateScreenOrientation, isPortrait: ${isPortrait}`);
    this.closeDialog();
    this.setLayoutRulerControllerOren(this.isPortrait);
  }

  private getLayoutRulerController(baseConfig?: BaseConfig): PcLayoutRulesController | undefined {
    if (!baseConfig) {
      log.showWarn(TAG, 'getLayoutRulerController, baseConfig undefined');
      return undefined;
    }
    return PcLayoutRulesController.getInstance(baseConfig, this.singleContext);
  }

  private closeDialog(): void {
    log.showInfo(TAG, 'closeDialog');
    AppStorage.setOrCreate('showUninstallDialog', false);
    this.fileOpDialogController?.close();
  }

  private initPowerSettings(): void {
    log.showInfo(TAG, `${TAG} initPowerSettings`);
    if (DeviceHelper.isPC() && DeviceHelper.isFold()) {
      this.initAcSwitchSettings();
    }
    let value: string = '';
    try {
      value = settings.getValueSync(getContext() as common.UIAbilityContext, SCREENOFF_AC_TIMEOUT_KEY, '',
        settings.domainName.USER_SECURITY);
    } catch (err) {
      log.showError(TAG, `${TAG} initPowerSettings getValueSync err, code: ${err?.code}, message: ${err?.message}`);
    }
    log.showInfo(TAG, `${TAG} initPowerSettings value: ${value}`);
    if (!value || value === IDLE_VALUE_30S) {
      log.showInfo(TAG, `${TAG} getAcValueSync fail,keyUrl: ${value}`);
      let ret: Boolean = false;
      try {
        ret = settings.setValueSync(getContext() as common.UIAbilityContext, SCREENOFF_AC_TIMEOUT_KEY,
          IDLE_DEFAULT_AC_VALUE, settings.domainName.USER_SECURITY);
        if (!ret) {
          log.showInfo(TAG, `${TAG} setAcValueSync error: fail to set idle screen off ac time`);
          return;
        }

        ret = settings.setValueSync(getContext() as common.UIAbilityContext, SCREENOFF_DC_TIMEOUT_KEY,
          IDLE_DEFAULT_DC_VALUE, settings.domainName.USER_SECURITY);
        if (!ret) {
          log.showInfo(TAG, `${TAG} setDcValueSync error: fail to set idle screen off dc time`);
          return;
        }
      } catch (e) {
        log.showInfo(TAG, `${TAG} setSettingsData error: ${e?.code}`);
      }
    }
  }

  private initAcSwitchSettings(): void {
    log.showInfo(TAG, `${TAG} initAcSwitchSettings`);
    let value: string = '';
    try {
      value = settings.getValueSync(getContext() as common.UIAbilityContext, SUSPEND_AC_SOURCES_KEY, '',
        settings.domainName.USER_SECURITY);
    } catch (e) {
      log.showError(TAG, `${TAG} initAcSwitchSettings getValueSync err, code: ${e.code}, message: ${e.message}`);
    }
    log.showInfo(TAG, `${TAG} initAcSwitchSettings value: ${value}`);
    if (!value) {
      log.showInfo(TAG, `${TAG} initAcSwitchSettings getAcValueSync fail,keyUrl: ${value}`);
      value = SUSPEND_AC_SOURCES_DEFAULT;
      let ret: Boolean = false;
      try {
        ret = settings.setValueSync(getContext() as common.UIAbilityContext, SUSPEND_AC_SOURCES_KEY,
          SUSPEND_AC_SOURCES_DEFAULT, settings.domainName.USER_SECURITY);
      } catch (e) {
        log.showError(TAG, `${TAG} initAcSwitchSettings setValueSync dafault error: ${e?.code}`);
      }
    }
    let data: object = [];
    try {
      data = JSON.parse(value) as object;
    } catch(e) {
      log.showError(TAG, `${TAG} initAcSwitchSettings parse value error: ${e?.code}`);
    }
    if (!data || !data['switch'] || !data['switch']['action']) {
      log.showError(TAG, `${TAG} initAcSwitchSettings data error`);
      return;
    }
    if (data['switch']['action'] === AC_SWITCH_SETTING_ZERO) {
      data['switch']['action'] = AC_SWITCH_SETTING_DEFAULT;
      value = JSON.stringify(data);
      let ret2: Boolean = false;
      try {
        ret2 = settings.setValueSync(getContext() as common.UIAbilityContext, SUSPEND_AC_SOURCES_KEY,
          value, settings.domainName.USER_SECURITY);
      } catch (e) {
        log.showInfo(TAG, `${TAG} initAcSwitchSettings setValueSync error: ${e?.code}`);
      }
    }
  }

  registerPageDesktopNavigatorStatusChangeEvent(listener: MLocalEventListener): void {
    localEventManager.registerEventListener(listener, [EventConstants.EVENT_NAVIGATOR_BAR_STATUS_CHANGE]);
  }

  private updateDesktopRotateState(): void {
    log.showInfo(TAG, 'updateDesktopRotateState: ' + JSON.stringify(this.screenProp));
    if (this.isFirstBoot && this.screenProp.screenId === 0) {
      this.screenPropertyChangeCallBack(this.screenProp,
        SCBPropertyChangeReason.ROTATION);
      const isVertical: boolean = this.screenProp.width < this.screenProp.height;
      return;
    }
    if (this.currScreenProperty.width !== 0 && this.currScreenProperty.height !== 0) {
      this.screenPropertyChangeCallBack(this.currScreenProperty as SCBScreenProperty,
        SCBPropertyChangeReason.ROTATION);
    }
  }

  private onOobeChangeEvent = (event: OobeActivatedEvent): void => {
    log.showInfo(TAG, `onOobeChangeEvent, state: ${event.isActivated}`);
    if (event.isActivated === false) {
      this.scaleValue = LockScreenAnimationController.DEFAULT_SCALE_RATIO;
      this.opacityValue = LockScreenAnimationController.DEFAULT_OPACITY_RATIO;
      log.showInfo(TAG,`scaleValue onOobeChangeEvent to ${this.scaleValue}`);
      if (AppStorage.get('isLock')) {
        // OOBE结束时在锁屏态，状态机不再锁横屏，需单独处理
        this.stateChangeOnOObeEnd();
        log.warn('current is locked, run oobe change event');
      }
    }
  }

  private stateChangeOnOObeEnd(): void {
    log.showInfo(TAG, 'other scene');
  }

  private initIconChange(): void {
    this.applyIconChange(true);
    try {
      settings.registerKeyObserver(getContext() as common.UIAbilityContext, 'isDesktopIconShowName', settings.domainName.DEVICE_SHARED,
        () => {
          this.applyIconChange();
        });
      settings.registerKeyObserver(getContext() as common.UIAbilityContext, 'desktopIconChangeSize', settings.domainName.USER_PROPERTY,
        () => {
          this.applyIconChange();
        });
    } catch (e) {
      log.showWarn(TAG, 'registerKeyObserver fail');
    }
  }

  private unregisterIconChange(): void {
    try {
      settings.unregisterKeyObserver(getContext() as common.UIAbilityContext, 'isDesktopIconShowName', settings.domainName.DEVICE_SHARED);
      settings.unregisterKeyObserver(getContext() as common.UIAbilityContext, 'desktopIconChangeSize', settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showWarn(TAG, 'unregisterKeyObserver fail');
    }
  }

  private async applyIconChange(isInit: boolean = false): Promise<void> {
    let iconSizeChangeValue: number = 0;
    try {
      const sizeChange = settings.getValueSync(getContext() as common.UIAbilityContext, 'desktopIconChangeSize', '0',
        settings.domainName.USER_PROPERTY);
      iconSizeChangeValue = Number(sizeChange);
    } catch (e) {
      log.showWarn(TAG, 'get desktopIconChangeSize fail');
      return;
    }
    if (isInit && iconSizeChangeValue === 0) {
      return;
    }
    AppStorage.setOrCreate<number>('settingIconChange', iconSizeChangeValue);
    PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('applyIconChange');
    BigFolderStyleConfig.getInstance().initConfig();
    FormStyleConfig.getInstance().initConfig();
    const iconChangeKey: number = iconSizeChangeValue;
    AppStorage.setOrCreate<number>('desktopIconChange', iconChangeKey);
  }

  private initDialog(): void {
    if (this.screenProp.screenId !== 0) {
      log.showInfo(TAG, 'initDialog, not main screen, return');
      return;
    }
    const appDialogController = new AppDialogController();
    appDialogController.init();
    const fileFolderDialogController = new FileFolderDialogController();
    fileFolderDialogController.init();
    const formDialogController = new FormDialogController();
    formDialogController.init();
    DialogController.initDialogController(DialogControllerType.DESKTOP_APP, appDialogController);
    DialogController.initDialogController(DialogControllerType.DESKTOP_FILE_FOLDER, fileFolderDialogController);
    DialogController.initDialogController(DialogControllerType.DESKTOP_FORM, formDialogController);
  }

  private destroyDialog(): void {
    if (this.screenProp.screenId !== 0) {
      log.showInfo(TAG, 'destroyDialog, not main screen, return');
      return;
    }
    DialogController.getDialogController(DialogControllerType.DESKTOP_APP)?.destroy();
    DialogController.removeDialogController(DialogControllerType.DESKTOP_APP);
    DialogController.getDialogController(DialogControllerType.DESKTOP_FILE_FOLDER)?.destroy();
    DialogController.removeDialogController(DialogControllerType.DESKTOP_FILE_FOLDER);
    DialogController.getDialogController(DialogControllerType.DESKTOP_FORM)?.destroy();
    DialogController.removeDialogController(DialogControllerType.DESKTOP_FORM);
  }

  aboutToDisappear(): void {
    FormEditViewProxy.getInstance().destroy();
    FormEditSecViewProxy.getInstance().destroy();
    this.destroyDialog();
    SCBSampleManager.getInstance().unRegisterKeyObserverSample();
    viewMgrPolicy.unregisterViewController(ViewType.SHUTDOWN_VIEW);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
    viewMgrPolicy.unRegisterViewCallback('SCBThemeEditor', this.themeEditViewCallback);
    ThemeStyleManager.getInstance().unregisterThemeEvent();
    ThemeStyleManager.getInstance().unRegisterThemeCallBack();
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.screenRotateChangeCallBack,
      this.screenProp?.screenId);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack,
      this.screenProp?.screenId);
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    this.eventMgr.offAll();
    log.showInfo(TAG, 'aboutToDisappear');
    reportIntervalMgr.unRegisterEvent(this.desktopItemsCountEvent);
    this.unregisterIconChange();
    this.getContext()?.eventHub.off('WindowStyleChange',
      this.flushDockStyle);
    GlobalContext.getContext()?.eventHub.off('changeDesktopOpacity', this.changeOpacity);
    FoldScreenReminder.getInstance().releaseAudioPlayer();
    SCBDesktopDebugCommand.getInstance().unregister();
    KnockShareManager.getInstance().destroyKnockShareInstance(this.persistentId);
    this.unregisterFoldAngleChangeEvent();
    keyEventManager.unRegisterKeyEventListener(this.escKeyEventListener);
    this.foldSwiperController?.unRegisterSwitchPageEvent();
  }

  onBackPress(): boolean {
    log.showInfo(TAG, 'onBackPress');
    ContextMenu.close();
    AppStorage.setOrCreate('dialogControllerStatus', !AppStorage.get<boolean>('dialogControllerStatus'));
    AppStorage.setOrCreate('overlayMode', CommonConstants.OVERLAY_TYPE_HIDE);
    AppStorage.setOrCreate('selectItem', '');
    return true;
  }

  build() {
    EffectComponent() {
      Stack() {
        // 服务互通弹窗组件
        if (!this.isLock) {
          /*CollaborationServiceStateDialog({
            onState: (stateCode: number, dataType?: string, buffer?: ArrayBuffer): void =>
            this.collaborationDialogModel.onStateProcess(stateCode, dataType, buffer)
          })
            .onAppear(() => {
              log.showInfo(TAG, 'cfwk watch isLock: %{public}s', this.isLock);
            })*/
        }
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          if (this.traceLog(true)) {
          }
          /*DialogComp({
            showInSubWindow: true,
            openCallback: (currentController: CustomDialogController) => {
              this.fileOpDialogController = currentController;
            },
            callback: () => {
              this.dismissCallback();
            }
          })*/
          Stack() {
            PageDesktopLayout({
              singleContext: this.singleContext,
              device: DeviceHelper.getDeviceType(),
              rightMenuViewModel: this.rightMenuViewModel
            }).scale({
              x: this.scaleValue,
              y: this.scaleValue,
              centerY: AppStorage.get('isLock') ? '50%' :
                px2vp(this.screenProp?.height) * LockScreenAnimationController.VISION_CENTER_RATIO_Y
            })
              .opacity(this.opacityValue)
            .id(`${TAG}_layout_container`)

          this.RotateImg()
        }
        .gesture(
          PanGesture({
            direction: PanDirection.None,
          })
            .onActionStart((event?: GestureEvent) => {
              this.foldSwiperController.switchPages(ActionType.BEGIN, event);
            })
            .onActionUpdate((event?: GestureEvent) => {
              this.foldSwiperController.switchPages(ActionType.UPDATE, event)
            })
            .onActionEnd((event?: GestureEvent) => {
              this.foldSwiperController.switchPages(ActionType.END, event)
            })
            .onActionCancel((event?: GestureEvent) => {
              this.foldSwiperController.switchPages(ActionType.CANCEL, event);
            })
        )
        .attributeModifier(this.modifier)
        .height(this.workSpaceHeight)
        if (this.traceLog()) {
        }
      }
      .width('100%')
      FormCenterView()
      DropAnimationItem()
    }
    .onBlur(() => {
      keyEventManager.resetCombKeyState();
    })
    .onKeyEvent((event?: KeyEvent) => {
      log.showInfo(TAG, `key event on grid coming: ${event?.keyCode}, ${event?.type}`);
      keyEventManager.dispatchKeyEvent(event);
    })
      .width('100%')
      .height('100%')
      .id(`${TAG}_Image_container`)
    }
    .backgroundEffect({
      radius: ResUtils.getNumber($r('app.float.regionfolder_blur_style_thin_radius')),
      saturation: ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')),
      color: $r('app.color.regionfolder_back_plane_bg_color')
    })
    .width('100%')
    .height('100%')
    .id(`${TAG}_EffectComponent`)
  }

  @Builder
  RotateImg() {
    Image(this.rotateImg)
      .objectFit(ImageFit.TOP_START)
      .scale({ x: 4, y: 4, centerX: '0%', centerY: '0%' })
      .opacity(this.rotateImgOpa)
      .syncLoad(true)
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)
      .clip(false)
      .onComplete((data) => {
        log.showInfo(TAG, `rotate image load completed state = ${data?.loadingStatus},isRotating: ${this.isRotating}`);
        if (data?.loadingStatus !== 1 || !this.isRotating) {
          log.showWarn(TAG, 'img status not 1');
          return;
        }
        animateToImmediately({ duration: 0 }, () => {});
        // 旋转动效下发后的Vsync信号再下发渐隐渐显动效，相距大约100ms，达到UX要求
        setTimeout(() => {
          log.showInfo(TAG, 'start screenshot rotate anim');
          animateTo({
            duration: 150,
            curve: Curve.Sharp,
            onFinish: (): void => {
              log.showInfo(TAG, 'end screenshot rotate anim');
            }
          }, () => {
            this.rotateImgOpa = 0;
            this.opacityValue = 1;
          })
        });
      })
  }

  private desktopItemsCount(): DesktopItemsCountParams {
    // 文件夹数量
    let folderNumber: number = 0;

    // 桌面卡片的数量
    let faNumber: number = 0;

    // 桌面应用图标的数量
    let appNumber: number = 0;

    // 桌面快捷方式图标数量
    let shortcutNumber: number = 0;

    // 桌面文件数量
    let fileNumber: number = 0;

    // 桌面大文件夹数量
    let regionFolderNumber: number = 0;
    this.appListInfo = AppStorage.get<AppListInfo>('appListInfo') as AppListInfo;
    this.appListInfo.appGridInfo.forEach((appItemInfo) => {
      if (CheckEmptyUtils.isEmpty(appItemInfo)) {
        return;
      }
      appItemInfo.forEach((appItemInfo) => {
        if (appItemInfo.typeId === CommonConstants.TYPE_APP) {
          appNumber++;
          return;
        }
        if (appItemInfo.typeId === CommonConstants.TYPE_CARD) {
          faNumber++;
          return;
        }
        if (appItemInfo.fileType === FileType.TYPE_FOLDER) {
          folderNumber++;
          return;
        }
        if (appItemInfo.fileType === FileType.TYPE_FILE) {
          fileNumber++;
          return;
        }
        if (appItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          shortcutNumber++;
          return;
        }
      });
    });
    let result: DesktopItemsCountParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: DisplayConstants.DEFAULT_DISPLAY,
      APPCNT: appNumber,
      FCNT: fileNumber,
      FDCNT: folderNumber,
      FACNT: faNumber,
      SCCNT: shortcutNumber,
      RFCNT: regionFolderNumber
    };
    return result;
  }

  private updateScreenInfo(): void {
    log.showDebug(TAG, 'updateScreenInfo, screenWidth: %{public}d, screenHeight: %{public}d', this.screenWidth,
      this.screenHeight);
    if (this.screenWidth != 0 && this.screenHeight != 0) {
      this.mLayoutViewModel.initScreen(this.navigationBarStatus);
      SmartDockStyleConfig.getInstance().initConfig();
      PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('updateScreenInfo');
      AppCenterGridStyleConfig.getInstance().initConfig();
      BigFolderStyleConfig.getInstance().initConfig();
      FormStyleConfig.getInstance().initConfig();
      this.updateScreenSize('updateScreenInfo');
    }
  }

  private updateScreenSize(callerTag?: string): void {
    log.showInfo(TAG, `updateScreenSize: ${callerTag}`);
    try {
      this.workSpaceWidth = this.screenWidth;
      this.workSpaceHeight = this.mLayoutViewModel.getWorkSpaceHeight();
      this.dockHeight = this.mLayoutViewModel.getDockHeight();
      AppStorage.setOrCreate('workSpaceWidth', this.workSpaceWidth);
      AppStorage.setOrCreate('workSpaceHeight', this.mLayoutViewModel.getWorkSpaceHeight());
      log.showInfo(TAG, 'updateScreenSize screenWidth: %{public}d, screenHeight: %{public}d,' +
        'workSpaceWidth: %{public}d, workSpaceHeight: %{public}d, dockHeight: %{public}d',
        this.screenWidth, this.screenHeight, this.workSpaceWidth, this.workSpaceHeight, this.dockHeight);
    } catch (error) {
      log.showError(TAG, `updateScreenSize error: ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * trace load desktop items start
   */
  private traceLog(isStart: boolean = false): boolean {
    log.showInfo(TAG, `trace start isStart: ${isStart}`);
    if (isStart) {
      Trace.start(Trace.CORE_METHOD_LOAD_DESKTOP_ITEMS);
    } else {
      Trace.end(Trace.CORE_METHOD_LOAD_DESKTOP_ITEMS);
    }
    return true;
  }

  private themeEditViewCallback: ViewCallback = {
    onHide: (): void => {
      ThemeStylePreviewManager.getInstance().clearPreviewResources();
    },
  };

  private desktopFocusCallback: ViewCallback = {
    onGainFocus: ():void => {
      log.showInfo(TAG, 'onGainFocus');
      DesktopStatusBarHelper.ensureVisibleOnDesktop('SCBDesktop.onGainFocus');
      this.desktopFocused = true;
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE, true);
    },
    onLoseFocus: ():void => {
      log.showInfo(TAG, 'onLoseFocus');
      this.desktopFocused = false;
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE, false);
    },
  };

  private desktopClearCallback: ViewCallback = {
    onTrimMemory: (level: TrimLevel): void => {
      switch (level) {
        case TrimLevel.LIGHT:
          this.clearDesktopMemory = !this.clearDesktopMemory;
          break;
        case TrimLevel.COMPLETE:
          this.releaseDesktopMemory = !this.releaseDesktopMemory;
          break;
      }
    },

  };

  private readonly mLocalEventListener: MLocalEventListener = {
    onReceiveEvent: (event: string, params: string) => {
      log.showDebug(TAG, `receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_NAVIGATOR_BAR_STATUS_CHANGE) {
        this.navigationBarStatus = params;
        this.updateScreenInfo();
      }
    }
  };

  private getPortrait(screenId: number): boolean {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (!screenSession) {
      log.showError(TAG, 'processOrientationUnrelatedToSensor screenSession is null');
      return true;
    }
    return SCBScreenSessionManager.getInstance().isScreenVertical(screenId);
  }

  private getWindowSize(screenProperty: SCBScreenProperty, callerTag?: string) {
    log.showInfo(TAG,
      'getWindowSize callerTag: %{public}s, screenWidth: %{public}d, screenHeight: %{public}d, screenId: %{public}d',
      callerTag, this.screenWidth, this.screenHeight, screenProperty?.screenId);
    try {
      this.screenWidth = px2vp(screenProperty.width);
      this.screenHeight = px2vp(screenProperty.height);
      AppStorage.setOrCreate('screenWidth', this.screenWidth);
      AppStorage.setOrCreate('screenHeight', this.screenHeight);
      FormEditLayout.setScreenRect(screenProperty.left, screenProperty.top, screenProperty.width, screenProperty.height);
      PcFileAccess.setDisplayId(screenProperty?.screenId);
      this.mLayoutViewModel.refreshConfig(screenProperty.width, screenProperty.height,
        0, false, 0, screenProperty.screenId);
      PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('displayUpdate');
      this.screenWidth = px2vp(screenProperty.width);
      this.screenHeight = px2vp(screenProperty.height);
      AppStorage.setOrCreate('screenWidth', this.screenWidth);
      AppStorage.setOrCreate('screenHeight', this.screenHeight);
      log.showInfo(TAG,
        'getWindowSize px2vp: %{public}d, screenWidth: %{public}d, screenHeight: %{public}d, screenId: %{public}d',
        px2vp(1), this.screenWidth, this.screenHeight, screenProperty.screenId);
    } catch (error) {
      log.showError(TAG, `getWindowWidth or getWindowHeight error: ${error?.message}`);
    }
  }

  private themeStyleCallback: ThemeStyleCallback = {
    onStyleChanged:(isIconActive: boolean): void => {
      if (isIconActive) {
        ResourceManager.getInstance().clearAppAllResourceCache();
        IconResourceManager.getInstance().clearAppResourceCache(`pcbase ${TAG} themeStyleChanged`);
      }

      PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('themeStyleCallback');
      SmartDockStyleConfig.getInstance().initConfig();
      FormStyleConfig.getInstance().initConfig();
    }
  }

  private lockDeskTopCallback(): void {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    this.scaleValue = LockScreenAnimationController.DESKTOP_SCALE_RATIO;
    log.showInfo(TAG,`scaleValue lockDeskTopCallback to ${this.scaleValue}`);
  }

  private themeEventCallBack(isIconsActivate: boolean, isHomeActivate: boolean): void {
    log.showInfo(TAG, 'enter themeEventCallBack');
    if (!isIconsActivate && !isHomeActivate) {
      log.showWarn(TAG, 'ThemeEventCallBack no icons or home activate.');
      return;
    }

    let theme = ThemeStyleManager.getInstance().loadThemeStyle();
    if (isHomeActivate) {
      PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('themeEventCallBack');
      SmartDockStyleConfig.setInPreviewMode(false);
      FormStyleConfig.getInstance().initConfig();
    }
    if (isIconsActivate) {
      ResourceManager.getInstance().clearAppAllResourceCache();
      IconResourceManager.getInstance().clearAppResourceCache(`pcbase ${TAG} themeEventCallBack`);
    }
    AppStorage.setOrCreate<string>('themeStyle', theme);
  }

  private dismissCallback(): void {
    log.showInfo(TAG, 'dismissCallback');
    setTimeout(() => {
      let ret: boolean = focusControl.requestFocus(`${TAG}_Image_container`);
      log.showInfo(TAG, `dismissCallback ret: ${ret}`);
    }, FOCUS_CHANGE_INTERVAL)
  }

  private closeDeskTopCallback(): void {
    this.scaleValue = PowerStatusChangeAnimationController.DESKTOP_SCALE_RATIO;
    this.opacityValue = PowerStatusChangeAnimationController.OPACITY_RATIO;
    log.showInfo(TAG,`scaleValue closeDeskTopCallback to ${this.scaleValue}`);
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  private flushDockStyle = (statusBarType: number) => {
    const currWorkSpaceTop: number = this.mPageDesktopStyleConfig.mWorkSpacePaddingTop +
    this.mPageDesktopStyleConfig.mWorkSpaceMarginTop;
    PcPageDesktopGridStyleConfig.getInstance(this.singleContext).initConfig('statusBarStyleChange');
    const gridOffset: number = this.mPageDesktopStyleConfig.mWorkSpacePaddingTop +
    this.mPageDesktopStyleConfig.mWorkSpaceMarginTop - currWorkSpaceTop;
    log.showInfo(TAG, `flushDockStyle: ${currWorkSpaceTop}, gridOffset: ${gridOffset}`);
    let fixedPage: number = -1;
    // 风格切换需改变配置文件mSysTopHeight的值
    PcLauncherLayoutStyleConfig.getInstance(this.singleContext).initSysTopHeight();
    this.getContext()?.eventHub.emit(EventConstants.EVENT_WORKSPACE_POSITION_CHANGE, gridOffset, fixedPage);
    this.getContext()?.eventHub.emit(EventConstants.EVENT_SUPER_FOLD_STATUS_CHANGE);
  }

  private registerFoldAngleChangeEvent(): void {
    if (this.isAngleChangeRegistered) {
      log.showWarn(TAG, 'angle change already registered');
      return;
    }

    this.isAngleChangeRegistered = true;
    try {
      display.on('foldAngleChange', this.onFoldAngleChange);
    } catch (err) {
      log.showError(TAG, `register foldAngleChange error, code:${err?.code}, message:${err?.message}`);
      this.isAngleChangeRegistered = false;
    }
  }

  private unregisterFoldAngleChangeEvent(): void {
    try {
      display.off('foldAngleChange', this.onFoldAngleChange);
    } catch (err) {
      log.showError(TAG, `off foldAngleChange error, code:${err?.code}, message:${err?.message}`);
    } finally {
      this.isAngleChangeRegistered = false;
      this.mFoldAngle = FOLD_ANGLE_180;
    }
  }

}

export class MLocalEventListener {
  public onReceiveEvent: Function = (event: string, params: string): void => {};
}