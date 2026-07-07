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

import { SCBAiBarConstants } from '../SCBAiBarConstants';
import { AiBarRegisterFunc, SCBAiBarProxyManager, } from '../proxy/SCBAiBarProxyManager';
import { display, performanceMonitor } from '@kit.ArkUI';
import {
  AiBarShowParam,
  AIBarViewData,
  AiBarStatusFlag,
  BarOpacityParam,
  BarRadiusParam,
  BarTranslateParam,
  WeakNotifyParam,
} from '../AIBarModel/AIBarViewData';
import { AIBarData } from '../AIBarModel/AIBarData';
import { AIBarViewModel } from '../AIBarModel/AIBarViewModel';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { animateExBreak } from '@ohos/windowscene/Index';
import { AccessibilityUtils } from '../util/AccessibilityUtils';
import { HiSysLongPressMisTouchType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import AIBarClickBackground from './AIBarClickBackground';
import { FloatingNavigationManager } from '../proxy/FloatingNavigationManager';
import { AiBarSettingsDataMgr } from '../settings/preference/AiBarSettingsDataMgr';
import { SwitchType } from '../settings/preference/PreferenceType';
import settings from '@ohos.settings';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import lazy { threeButtonAccessibilityMgr } from '../settings/preference/ThreeButtonAccessibilityManager';
import { NavbarWindowManager } from '../../gesturenavigation/navbar/viewmodel/NavbarWindowManager';
// import { HdsSceneController, HdsSceneType, HdsVisualComponent, HdsVisualComponentAttribute } from '@kit.UIDesignKit';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { AiBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/AiBarVisualEffectManager';

const TAG = 'AIBarView';
const AIBAR_TAG = 'AIBAR';
const DRAG_TO_VOICE_FONT_SIZE = `${SCBAiBarConstants.DRAG_TO_VOICE_FONT_SIZE}vp`;
const SPACE = ' ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

@Component
export default struct AIBarView {
  persistentId: number = 0;
  @Link screenProperty: SCBScreenProperty;
  @Link viewController: BaseViewController;
  private readonly aiBarViewModel: AIBarViewModel = AIBarViewModel.getInstance(this.screenProperty);
  private readonly appModel: AppModel = AppModel.getInstance();
  private readonly navBarViewModel: SCBGestureNavBarViewModel = SCBGestureNavBarViewModel.getInstance();
  private readonly navbarWindowManager: NavbarWindowManager = this.navBarViewModel.windowManager;
  private aiBarData: AIBarData = AIBarData.getInstance();
  @State aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
  @State barTranslateParam: BarTranslateParam = this.aiBarViewData.barTranslateParam;
  @State barRadiusParam: BarRadiusParam = this.aiBarViewData.barRadiusParam;
  @State barOpacityParam: BarOpacityParam = this.aiBarViewData.barOpacityParam;
  @State weakNotifyParam: WeakNotifyParam = this.aiBarViewData.weakNotifyParam;
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
        case EventConstants.EVENT_AI_BAR_STATUS_CHANGE:
          log.showInfo(`[${AIBAR_TAG}] receive EVENT_AI_BAR_STATUS_CHANGE, params=${params}`);
          if (this.aiBarViewData.isNavigationBarEnable) {
            break;
          }
          if (this.aiBarViewData.isTempShowAiBar) {
            return;
          }
          FloatingNavigationManager.getInstance().notifyFloatingNavImmerseStatus(params);
          this.aiBarViewData.isTempShowAiBar = true;
          clearTimeout(this.aiBarData.immerseHideAiBarTimer);
          clearTimeout(this.aiBarData.eventAiBarStatusChange);
          this.aiBarData.eventAiBarStatusChange = setTimeout(() => {
            clearTimeout(this.aiBarData.eventAiBarStatusChange);
            this.aiBarViewData.isTempShowAiBar = false;
            log.showInfo(`[${AIBAR_TAG}] receive EVENT_AI_BAR_STATUS_CHANGE`);
          }, 2000);
          break;
        case EventConstants.SYSTEM_BAR_CHANGE:
          let tempShowAiBar = (params === SystemBarChangeType.AI_BAR_IMMERSE_TASK);
          FloatingNavigationManager.getInstance().notifyFloatingNavImmerseStatus(params);
          log.showInfo(`[${AIBAR_TAG}] receive SYSTEM_BAR_CHANGE, params=${params}, tempShowAiBar=${tempShowAiBar}`);
          if (tempShowAiBar) {
            clearTimeout(this.aiBarData.navBarDisappearWithStatusBar);
            this.aiBarViewData.isTempShowAiBar = tempShowAiBar;
            this.aiBarData.navBarDisappearWithStatusBar = setTimeout(() => {
              clearTimeout(this.aiBarData.navBarDisappearWithStatusBar);
              log.showInfo(`clearTimeout id is:${this.aiBarData.navBarDisappearWithStatusBar}`);
              this.aiBarViewData.isTempShowAiBar = !tempShowAiBar;
              log.showInfo(`[${AIBAR_TAG}] receive SYSTEM_BAR_CHANGE`);
            }, 4250);
            log.showInfo(`setTimeout id is:${this.aiBarData.navBarDisappearWithStatusBar}`);
          }
          break;
        default:
          break;
      }
    }
  };
  private foldStatusChangeCallback = (foldDisplayMode: display.FoldDisplayMode) => {
    log.showInfo(`foldDisplayModeChange ${foldDisplayMode}`);
    this.aiBarData.foldDisplayMode = foldDisplayMode;
  };
  // SceneState切换状态回调
  private sceneStateChange: SceneStateChangeCallback = (sceneInfo, isForeground) => {
    this.aiBarViewModel.checkIsInMidScene();
    // 非全屏状态，this.isEnterDeliver 的值对导航条无影响，无需变更，全屏状态下只需判断当前是EnterDeliver即可
    if (!this.aiBarViewData.isInFullScreen()) {
      return;
    }
    const intent = this.appModel.getAppInfoByBundleName(sceneInfo.bundleName)?.intent;
    this.aiBarViewData.isEnterDeliver = DeliverUtil.isContainerItem(intent);
    log.showInfo(`bundleName:${sceneInfo.bundleName} isEnterDeliver:${this.aiBarViewData.isEnterDeliver}`);
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
        EventConstants.EVENT_AI_BAR_STATUS_CHANGE]);
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
    this.aiBarViewData.scenePanelState = this.scenePanelState;
    this.navbarWindowManager.updateByScenePanelState(this.scenePanelState);
  }

  private updateSpecialScenePanelState(): void {
    log.showInfo(`specialScenePanelState has change to ${this.specialScenePanelState}`);
    this.aiBarViewData.specialScenePanelState = this.specialScenePanelState;
  }

  private updateDesktopDrag(): void {
    log.showInfo(`isDesktopDrag has change to ${this.isDesktopDrag}`);
    this.aiBarData.isDesktopDrag = this.isDesktopDrag;
  }

  private onDesktopDragItemInfoChange(): void {
    log.showInfo(`desktopDragItemInfo has change to ${this.desktopDragItemInfo?.infoId}`);
    if (!CheckEmptyUtils.isEmpty(this.desktopDragItemInfo.infoId)) {
      // 拖拽开始 desktopDragItemInfo 变化
      this.aiBarData.desktopDragItemInfo = this.desktopDragItemInfo;
    }
  }

  private checkShowAiBar(): boolean {
    log.showInfo('checkShowAiBar');
    let aiBarShowParam = this.constructAiBarShowParam();
    this.aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam);
    this.aiBarViewModel.resetHotAreaHeightInGame();
    return this.aiBarViewData.isShowingAiBar;
  }

  private constructAiBarShowParam() {
    let aiBarShowParam = new AiBarShowParam();
    aiBarShowParam.scenePanelState = this.scenePanelState;
    aiBarShowParam.navBarIsShow = this.aiBarViewData.navBarIsShow;
    aiBarShowParam.isNavigationBarEnable = this.aiBarViewData.isNavigationBarEnable;
    // 导航条存在的情况下在拖动状态下保证导航条不消失
    aiBarShowParam.isTempShowAiBar = this.aiBarViewData.isTempShowAiBar || this.aiBarData.isAiBarExistWhenDragStart;
    aiBarShowParam.screenProperty = this.screenProperty;
    aiBarShowParam.isInEmergencyOrThermalSafeMode = this.aiBarViewData.isInEmergencyOrThermalSafeMode;
    aiBarShowParam.isInOutLauncher = launcherStatusUtil.getShowOutLauncherStatus();
    return aiBarShowParam;
  }

  @Builder
  weakNotifyNavigationBuilder() {
    Row() {
    }
    .width(SCBAiBarConstants.NAVIGATION_LENGTH_BASE * this.aiBarViewData.capsuleWidth)
    .height(this.aiBarViewData.capsuleHeight)
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
  dragAiBarBuilder() {
    Stack() {
      if (this.aiBarViewData.isInFullScreen()) {
        this.commonNavBarBuilder();
      } else {
        this.desktopNavBarBuilder();
      }
    }
    .alignContent(Alignment.Center)
    .width(this.aiBarViewData.capsuleWidth)
    .height(this.aiBarViewData.capsuleHeight)
    .scale(this.aiBarViewData.capsuleScale)
    .borderRadius('50%')
    .translate({
      y: this.barTranslateParam.barTranslateY - this.aiBarViewData.aiBarBottomMargin,
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
    .backgroundEffect({ radius: SCBAiBarConstants.DESKTOP_AIBAR_BLUR_RADIUS }, { disableSystemAdaptation: true })
    .backgroundColor('#FFFFFFFF')
    .backgroundBrightnessInternal(this.aiBarViewData.brightnessOptions)
    .alignItems(HorizontalAlign.Start)
    .navBarStyle()
  }

  @Builder
  commonNavBarBuilder() {
    if (this.aiBarViewData.isNeedToUsePureColor()) {
      Column() {
        this.weakNotifyNavigationBuilder();
      }
      .onAttach(() => { TraceUtil.traceOnce(DomainName.SCB, 'changeToSolidColor'); })
      .backgroundColor(SCBAiBarConstants.LOW_POWER_AIBAR_COLOR)
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
    .width(this.aiBarViewData.capsuleWidth)
    .height(this.aiBarViewData.capsuleHeight)
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
    if (this.checkShowAiBar()) {
      Stack() {
        this.dragAiBarBuilder();
        if (this.aiBarViewData.clickBackStatus) {
          AIBarClickBackground();
        }
      }
      .accessibilityText($r('app.string.ai_bar_accessibility_text'))
      .accessibilityDescription(SPACE)
      .onDisAppear(() => {
      })
      .accessibilityLevel(this.aiBarViewData.getAibarAccessibilityLevel())
      .opacity(this.aiBarViewData.getAibarOpacity())
      .enabled(this.aiBarViewData.getAibarOpacity() === 1)
      .transition(this.aiBarViewModel.aiBarAnimate.getTransitionEffect(this.aiBarViewData.isNavigationBarEnable))
      .geometryTransition('NotificationCapsule', { follow: false })
      .id(`${TAG}_Stack_HotArea`)
      .width(this.aiBarViewData.capsuleWidth)
      .height(StyleConstants.PERCENTAGE_100)
      .align(Alignment.Bottom)
      .allowDrop(this.getAllowDropType())
      .aiBarOnClick()
      .onTouch((event: TouchEvent) => this.navBarViewModel.navBarOnTouch(event,
        this.aiBarViewData.isNavigationBarEnable))
    }
  }

  @Styles
  aiBarOnClick() {
    .onClick(async () => {
      log.showInfo('SCBAiNavBar ClickEvent');
      let clickBackTimes =
        this.aiBarData.aiBarSettingsDataMgr.getNumberValueSync(SCBAiBarConstants.CLICK_BACK, '0');
      log.showInfo(`clickBackTimes is ${clickBackTimes}, clickBackStatus is ${this.aiBarViewData.clickBackStatus}`);
      if (clickBackTimes === 0) {
        this.aiBarData.aiBarSettingsDataMgr.putValue(SCBAiBarConstants.CLICK_BACK, '1');
      }
      HiSysEventUtil.reportOnClickAIBar(this.aiBarViewData.clickBackStatus);
      // 桌面拖拽禁止AiBar点击返回手势
      if (this.aiBarViewData.clickBackStatus &&
        scbEventExclusiveManager.isExclusive(EventType.AI_BAR_CLICK_BACK)) {
        log.showInfo('Gesture exclusion forbids click back');
        return;
      }
      if (!this.aiBarData.is2DRelease && this.aiBarViewData.clickBackStatus) {
        this.aiBarViewModel.aiBarAnimate.processBackEventAnimate();
        this.aiBarViewModel.processBackEvent();
      }
    })
  }

  private getAllowDropType(): uniformTypeDescriptor.UniformDataType[] {
    // 返回[]时，桌面拖拽图标时不要加角标
    if (this.isDesktopDrag) {
      return [];
    }
    if (!this.aiBarViewData.isShowingAiBar) {
      return [];
    }
    if (this.checkAllowDropTypeByAiBarViewData()) {
      return [];
    }
    return this.aiBarData.aiBarAllowDropType;
  }

  private checkAllowDropTypeByAiBarViewData(): boolean {
    if (this.aiBarViewData.getAibarOpacity() === 0) {
      return true;
    }
    if (this.aiBarViewData.isOffInputMonitor) {
      return true;
    }
    return false;
  }
}
