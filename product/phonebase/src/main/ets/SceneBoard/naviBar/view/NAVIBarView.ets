/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CheckEmptyUtils, DomainName, LogDomain, LogHelper, TraceUtil, } from '@ohos/basicutils';
import { DeviceHelper, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DragConstants } from '@ohos/commonconstants';
import {
  EventType,
  launcherStatusUtil,
  ResUtils,
  scbEventExclusiveManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import {
  SCBSceneSessionManager,
  ScenePanelState,
  SceneStateChangeCallback,
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import {
  AppModel,
  DeliverUtil,
  EventConstants,
  GridLayoutItemInfo,
  ReceiveEventInfo,
  vibratorMgr,
  CommonConstants
} from '@ohos/launchercommon';
import { SystemBarChangeType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragEventType, SCBGestureNavBarViewModel, } from '../../gesturenavigation/SCBGestureNavBarViewModel';

import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { NaviBarRegisterFunc, SCBNaviBarProxyManager, } from '../proxy/SCBNaviBarProxyManager';
import { display, performanceMonitor } from '@kit.ArkUI';
import {
  NaviBarShowParam,
  NAVIBarViewData,
  NaviBarStatusFlag,
  BarOpacityParam,
  BarRadiusParam,
  BarTranslateParam,
  WeakNotifyParam,
} from '../NAVIBarModel/NAVIBarViewData';
import { NAVIBarData } from '../NAVIBarModel/NAVIBarData';
import { NAVIBarViewModel } from '../NAVIBarModel/NAVIBarViewModel';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { animateExBreak } from '@ohos/windowscene/Index';
import { AccessibilityUtils } from '../util/AccessibilityUtils';
import { HiSysLongPressMisTouchType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import NAVIBarClickBackground from './NAVIBarClickBackground';
import { FloatingNavigationManager } from '../proxy/FloatingNavigationManager';
import { NaviBarSettingsDataMgr } from '../settings/preference/NaviBarSettingsDataMgr';
import { SwitchType } from '../settings/preference/PreferenceType';
import settings from '@ohos.settings';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import lazy { threeButtonAccessibilityMgr } from '../settings/preference/ThreeButtonAccessibilityManager';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
// import { HdsSceneController, HdsSceneType, HdsVisualComponent, HdsVisualComponentAttribute } from '@kit.UIDesignKit';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { NaviBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/NaviBarVisualEffectManager';

const TAG = 'NAVIBarView';
const NAVIBAR_TAG = 'NAVIBAR';
const DRAG_TO_VOICE_FONT_SIZE = `${SCBNaviBarConstants.DRAG_TO_VOICE_FONT_SIZE}vp`;
const SPACE = ' ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

@Component
export default struct NAVIBarView {
  persistentId: number = 0;
  @Link screenProperty: SCBScreenProperty;
  @Link viewController: BaseViewController;
  private readonly naviBarViewModel: NAVIBarViewModel = NAVIBarViewModel.getInstance(this.screenProperty);
  private readonly appModel: AppModel = AppModel.getInstance();
  private readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  private naviBarData: NAVIBarData = NAVIBarData.getInstance();
  @State naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
  @State barTranslateParam: BarTranslateParam = this.naviBarViewData.barTranslateParam;
  @State barRadiusParam: BarRadiusParam = this.naviBarViewData.barRadiusParam;
  @State barOpacityParam: BarOpacityParam = this.naviBarViewData.barOpacityParam;
  @State weakNotifyParam: WeakNotifyParam = this.naviBarViewData.weakNotifyParam;
  @StorageProp('scenePanelState') @Watch('updateScenePanelState') scenePanelState: ScenePanelState =
    ScenePanelState.HOME;
  @StorageProp('specialScenePanelState') @Watch('updateSpecialScenePanelState') specialScenePanelState: ScenePanelState =
    ScenePanelState.HOME;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageProp('isDrag') @Watch('updateDesktopDrag') isDesktopDrag: boolean = false;
  @StorageProp('dragItemInfo') @Watch('onDesktopDragItemInfoChange') desktopDragItemInfo: GridLayoutItemInfo =
    new GridLayoutItemInfo();
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number | boolean): void => {
      switch (event) {
        case EventConstants.EVENT_NAVI_BAR_STATUS_CHANGE:
          log.showInfo(`[${NAVIBAR_TAG}] receive EVENT_NAVI_BAR_STATUS_CHANGE, params=${params}`);
          if (this.naviBarViewData.isNavigationBarEnable) {
            break;
          }
          if (this.naviBarViewData.isTempShowNaviBar) {
            return;
          }
          FloatingNavigationManager.getInstance().notifyFloatingNavImmerseStatus(params);
          this.naviBarViewData.isTempShowNaviBar = true;
          clearTimeout(this.naviBarData.immerseHideNaviBarTimer);
          clearTimeout(this.naviBarData.eventNaviBarStatusChange);
          this.naviBarData.eventNaviBarStatusChange = setTimeout(() => {
            clearTimeout(this.naviBarData.eventNaviBarStatusChange);
            this.naviBarViewData.isTempShowNaviBar = false;
            log.showInfo(`[${NAVIBAR_TAG}] receive EVENT_NAVI_BAR_STATUS_CHANGE`);
          }, 2000);
          break;
        case EventConstants.SYSTEM_BAR_CHANGE:
          let tempShowNaviBar = (params === SystemBarChangeType.NAVI_BAR_IMMERSE_TASK);
          FloatingNavigationManager.getInstance().notifyFloatingNavImmerseStatus(params);
          log.showInfo(`[${NAVIBAR_TAG}] receive SYSTEM_BAR_CHANGE, params=${params}, tempShowNaviBar=${tempShowNaviBar}`);
          if (tempShowNaviBar) {
            clearTimeout(this.naviBarData.navBarDisappearWithStatusBar);
            this.naviBarViewData.isTempShowNaviBar = tempShowNaviBar;
            this.naviBarData.navBarDisappearWithStatusBar = setTimeout(() => {
              clearTimeout(this.naviBarData.navBarDisappearWithStatusBar);
              log.showInfo(`clearTimeout id is:${this.naviBarData.navBarDisappearWithStatusBar}`);
              this.naviBarViewData.isTempShowNaviBar = !tempShowNaviBar;
              log.showInfo(`[${NAVIBAR_TAG}] receive SYSTEM_BAR_CHANGE`);
            }, 4250);
            log.showInfo(`setTimeout id is:${this.naviBarData.navBarDisappearWithStatusBar}`);
          }
          break;
        default:
          break;
      }
    }
  };
  private foldStatusChangeCallback = (foldDisplayMode: display.FoldDisplayMode) => {
    log.showInfo(`foldDisplayModeChange ${foldDisplayMode}`);
    this.naviBarData.foldDisplayMode = foldDisplayMode;
  };
  // SceneState切换状态回调
  private sceneStateChange: SceneStateChangeCallback = (sceneInfo, isForeground) => {
    this.naviBarViewModel.checkIsInMidScene();
    // 非全屏状态，this.isEnterDeliver 的值对导航条无影响，无需变更，全屏状态下只需判断当前是EnterDeliver即可
    if (!this.naviBarViewData.isInFullScreen()) {
      return;
    }
    const intent = this.appModel.getAppInfoByBundleName(sceneInfo.bundleName)?.intent;
    this.naviBarViewData.isEnterDeliver = DeliverUtil.isContainerItem(intent);
    log.showInfo(`bundleName:${sceneInfo.bundleName} isEnterDeliver:${this.naviBarViewData.isEnterDeliver}`);
  };

  private monitorFoldStatus(): void {
    try {
      display.on('foldDisplayModeChange', this.foldStatusChangeCallback);
    } catch (error) {
      log.showError(`on foldDisplayModeChange error ${error}`);
    }
  }

  aboutToAppear(): void {
    SCBSceneSessionManager.getInstance()
      .registerSceneStateChangeCallback(SCBSceneSessionManager.getInstance().mainScreenId, this.sceneStateChange);
    localEventManager.registerEventListener(this.localEventListener,
      [EventConstants.SYSTEM_BAR_CHANGE,
        EventConstants.EVENT_NAVI_BAR_STATUS_CHANGE]);
    this.monitorFoldStatus();
  }

  aboutToDisappear(): void {
    SCBSceneSessionManager.getInstance()
      .unregisterSceneStateChangeCallback(SCBSceneSessionManager.getInstance().mainScreenId, this.sceneStateChange);
    localEventManager.unregisterEventListener(this.localEventListener);
    try {
      display.off('foldDisplayModeChange', this.foldStatusChangeCallback);
    } catch (e) {
      log.showError(`off foldDisplayModeChange error, code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  private updateScenePanelState(): void {
    log.showInfo(`ScenepanelState has change to ${this.scenePanelState}`);
    this.naviBarViewData.scenePanelState = this.scenePanelState;
    this.navbarWindowManager.updateByScenePanelState(this.scenePanelState);
  }

  private updateSpecialScenePanelState(): void {
    log.showInfo(`specialScenePanelState has change to ${this.specialScenePanelState}`);
    this.naviBarViewData.specialScenePanelState = this.specialScenePanelState;
  }

  private updateDesktopDrag(): void {
    log.showInfo(`isDesktopDrag has change to ${this.isDesktopDrag}`);
    this.naviBarData.isDesktopDrag = this.isDesktopDrag;
  }

  private onDesktopDragItemInfoChange(): void {
    log.showInfo(`desktopDragItemInfo has change to ${this.desktopDragItemInfo?.infoId}`);
    if (!CheckEmptyUtils.isEmpty(this.desktopDragItemInfo.infoId)) {
      // 拖拽开始 desktopDragItemInfo 变化
      this.naviBarData.desktopDragItemInfo = this.desktopDragItemInfo;
    }
  }

  private checkShowNaviBar(): boolean {
    log.showInfo('checkShowNaviBar');
    let naviBarShowParam = this.constructNaviBarShowParam();
    this.naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam);
    this.naviBarViewModel.resetHotAreaHeightInGame();
    return this.naviBarViewData.isShowingNaviBar;
  }

  private constructNaviBarShowParam() {
    let naviBarShowParam = new NaviBarShowParam();
    naviBarShowParam.scenePanelState = this.scenePanelState;
    naviBarShowParam.navBarIsShow = this.naviBarViewData.navBarIsShow;
    naviBarShowParam.isNavigationBarEnable = this.naviBarViewData.isNavigationBarEnable;
    // 导航条存在的情况下在拖动状态下保证导航条不消失
    naviBarShowParam.isTempShowNaviBar = this.naviBarViewData.isTempShowNaviBar || this.naviBarData.isNaviBarExistWhenDragStart;
    naviBarShowParam.screenProperty = this.screenProperty;
    naviBarShowParam.isInEmergencyOrThermalSafeMode = this.naviBarViewData.isInEmergencyOrThermalSafeMode;
    naviBarShowParam.isInOutLauncher = launcherStatusUtil.getShowOutLauncherStatus();
    return naviBarShowParam;
  }

  @Builder
  weakNotifyNavigationBuilder() {
    Row() {
    }
    .width(SCBNaviBarConstants.NAVIGATION_LENGTH_BASE * this.naviBarViewData.capsuleWidth)
    .height(this.naviBarViewData.capsuleHeight)
    .opacity(this.weakNotifyParam.weakNotifyOpacity)
    .visibility(this.weakNotifyParam.weakNotifyVisibility)
    .linearGradient({
      direction: GradientDirection.Right,
      repeating: false,
      colors: this.weakNotifyParam.weakNotifyColorList
    })
    .translate({ x: this.weakNotifyParam.weakNotifyPlayPosition, y: 0 })
    .borderRadius(this.barRadiusParam.barRadius)
  }

  @Builder
  dragNaviBarBuilder() {
    Stack() {
      if (this.naviBarViewData.isInFullScreen()) {
        this.commonNavBarBuilder();
      } else {
        this.desktopNavBarBuilder();
      }
    }
    .alignContent(Alignment.Center)
    .width(this.naviBarViewData.capsuleWidth)
    .height(this.naviBarViewData.capsuleHeight)
    .scale(this.naviBarViewData.capsuleScale)
    .borderRadius('50%')
    .translate({
      y: this.barTranslateParam.barTranslateY - this.naviBarViewData.naviBarBottomMargin,
      x: this.barTranslateParam.barTranslateX
    })
    .clip(true)
  }

  @Builder
  desktopNavBarBuilder() {
    Column() {
      this.weakNotifyNavigationBuilder();
    }
    .onAttach(() => { TraceUtil.traceOnce(DomainName.SCB, 'changeToDesktopColor'); })
    .backgroundEffect({ radius: SCBNaviBarConstants.DESKTOP_NAVIBAR_BLUR_RADIUS }, { disableSystemAdaptation: true })
    .backgroundColor('#FFFFFFFF')
    .backgroundBrightnessInternal(this.naviBarViewData.brightnessOptions)
    .alignItems(HorizontalAlign.Start)
    .navBarStyle()
  }

  @Builder
  commonNavBarBuilder() {
    if (this.naviBarViewData.isNeedToUsePureColor()) {
      Column() {
        this.weakNotifyNavigationBuilder();
      }
      .onAttach(() => { TraceUtil.traceOnce(DomainName.SCB, 'changeToSolidColor'); })
      .backgroundColor(SCBNaviBarConstants.LOW_POWER_NAVIBAR_COLOR)
      .alignItems(HorizontalAlign.Start)
      .navBarStyle()
    } else {
      Column() {
        this.weakNotifyNavigationBuilder();
      }
      .onAttach(() => { TraceUtil.traceOnce(DomainName.SCB, 'changeToReverseColor'); })
      .systemBarEffect()
      .alignItems(HorizontalAlign.Start)
      .navBarStyle()
    }
  }

  @Styles
  navBarStyle() {
    .width(this.naviBarViewData.capsuleWidth)
    .height(this.naviBarViewData.capsuleHeight)
    .borderRadius(this.barRadiusParam.barRadius)
    .clip(true)
    .opacity(this.barOpacityParam.barOpacity)
    .id(`${TAG}_Column_Bar`)
    .geometryTransition('navBarId')
    .transition(TransitionEffect.OPACITY.animation({
      curve: Curve.Linear,
      duration: 300
    }))
  }

  build() {
    if (this.checkShowNaviBar()) {
      Stack() {
        this.dragNaviBarBuilder();
        if (this.naviBarViewData.clickBackStatus) {
          NAVIBarClickBackground();
        }
      }
      .accessibilityText($r('app.string.navi_bar_accessibility_text'))
      .accessibilityDescription(SPACE)
      .onDisAppear(() => {
      })
      .accessibilityLevel(this.naviBarViewData.getNavibarAccessibilityLevel())
      .opacity(this.naviBarViewData.getNavibarOpacity())
      .enabled(this.naviBarViewData.getNavibarOpacity() === 1)
      .transition(this.naviBarViewModel.naviBarAnimate.getTransitionEffect(this.naviBarViewData.isNavigationBarEnable))
      .geometryTransition('NotificationCapsule', { follow: false })
      .id(`${TAG}_Stack_HotArea`)
      .width(this.naviBarViewData.capsuleWidth)
      .height(StyleConstants.PERCENTAGE_100)
      .align(Alignment.Bottom)
      .allowDrop(this.getAllowDropType())
      .naviBarOnClick()
      .onTouch((event: TouchEvent) => this.navBarViewModel.navBarOnTouch(event,
        this.naviBarViewData.isNavigationBarEnable))
    }
  }

  @Styles
  naviBarOnClick() {
    .onClick(async () => {
      log.showInfo('SCBAiNavBar ClickEvent');
      let clickBackTimes =
        this.naviBarData.naviBarSettingsDataMgr.getNumberValueSync(SCBNaviBarConstants.CLICK_BACK, '0');
      log.showInfo(`clickBackTimes is ${clickBackTimes}, clickBackStatus is ${this.naviBarViewData.clickBackStatus}`);
      if (clickBackTimes === 0) {
        this.naviBarData.naviBarSettingsDataMgr.putValue(SCBNaviBarConstants.CLICK_BACK, '1');
      }
      HiSysEventUtil.reportOnClickNAVIBar(this.naviBarViewData.clickBackStatus);
      // 桌面拖拽禁止NaviBar点击返回手势
      if (this.naviBarViewData.clickBackStatus &&
        scbEventExclusiveManager.isExclusive(EventType.NAVI_BAR_CLICK_BACK)) {
        log.showInfo('Gesture exclusion forbids click back');
        return;
      }
      if (!this.naviBarData.is2DRelease && this.naviBarViewData.clickBackStatus) {
        this.naviBarViewModel.naviBarAnimate.processBackEventAnimate();
        this.naviBarViewModel.processBackEvent();
      }
    })
  }

  private getAllowDropType(): uniformTypeDescriptor.UniformDataType[] {
    // 返回[]时，桌面拖拽图标时不要加角标
    if (this.isDesktopDrag) {
      return [];
    }
    if (!this.naviBarViewData.isShowingNaviBar) {
      return [];
    }
    if (this.checkAllowDropTypeByNaviBarViewData()) {
      return [];
    }
    return this.naviBarData.naviBarAllowDropType;
  }

  private checkAllowDropTypeByNaviBarViewData(): boolean {
    if (this.naviBarViewData.getNavibarOpacity() === 0) {
      return true;
    }
    if (this.naviBarViewData.isOffInputMonitor) {
      return true;
    }
    return false;
  }
}
