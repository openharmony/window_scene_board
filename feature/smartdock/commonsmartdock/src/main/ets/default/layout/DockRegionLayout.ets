/**
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

import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import {
  DeviceHelper,
  DockAvgColorChangeEvent,
  EvtBus,
  GlobalContext,
  HiDfxEventUtil,
  ScreenState,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WallpaperColorManager
} from '@ohos/frameworkwrapper';
import {
  SCBExpandController,
  SCBSceneSessionManager,
  SCBTransitionManager,
  SCBUnlockTransitionController
} from '@ohos/windowscene';
import { RTLUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import {
  CommonConstants,
  DockItemInfo,
  EventConstants,
  layoutConfigManager,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import curves from '@ohos.curves';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import BackPlane from '../common/component/BackPlane';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { DockAppItem } from './DockAppItem';
import { NumberConstants, VisualEffectConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { IDividerDragEvent } from '../interface/IDividerDragEvent';
import { ILayoutRefreshHandler } from '../interface/ILayoutRefreshHandler';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { DockRegionAnimationVm } from '../viewmodel/DockRegionAnimationVm';
import { DockRegionAnimationEvent } from '../viewmodel/DockRegionAnimationEvent';
import { DockRegionLayoutPropertyVm } from '../viewmodel/DockRegionLayoutPropertyVm';
import lazy {
  SCBTripleStateChange,
  TripleFoldExpandAnimUtils,
} from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import lazy {
  TripleFoldAnimationConstants
} from '@ohos/launchercommon/src/main/ets/constants/TripleFoldAnimationConstants';
import lazy { RecentDockAnimationEvent } from '@ohos/launchercommon/src/main/ets/events/RecentDockEvents';
import { SmartDockObserver } from '../viewmodel/smartDockObserver';
import lazy { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';

const TAG = 'SmartDock_V_DockRegionLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * DockRegionLayout
 *
 * @since 2025-01-07
 */
@Component
export default struct DockRegionLayout {
  @Prop singleContext?: SingleContext;
  recentDockMaxNumber: number = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
  smartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  onItemClick?: Function;
  buildMenu?: Function;
  private deviceType: string = '';
  private region: DockRegionType = DockRegionType.RECENT;
  // 事件处理类
  private dividerDragEvent?: IDividerDragEvent;
  private refreshHandler: ILayoutRefreshHandler = {
    calculateLayoutWidth: (): number => {
      throw new Error('Function not implemented.');
    },
    reloadItems: (): Array<DockItemInfo> => {
      throw new Error('Function not implemented.');
    }
  };
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_smartdock`,
    onLock: (): void => {
    },
    onUnlock: (): void => {},
    onUnlockStartScene: (): void => this.onUnlockStartSceneReceived(),
    onUnlockAnimation: (): void => this.residentOnUnLockReceived(),
  };
  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn()
  };
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private expandController?: SCBExpandController;
  private layoutModel: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
  @State backPlaneBgColor: string | undefined = WallpaperColorManager.getInstance().getBackPlaneColor();
  @State lastLayoutWidth: number = 0;
  @StorageLink('recentLayoutAdditionWidth') recentLayoutAdditionWidth: number = 0;
  @State isDragIng: boolean = false; //适配解锁动效，不允许布局切断
  @State isOnContinueItemDisappear: boolean = false;
  @State items: Array<DockItemInfo> = [];
  @State @Watch('onLayoutChanged') layoutWidth: number = 0;
  @State @Watch('onUnLockReceived') isUnLockReceived: boolean = false;
  @State @Watch('onLockReceived') isLockReceived: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageProp('desktopIconChange') @Watch('onThemeChange') desktopIconChange: number = 0;
  @StorageProp('themeStylePreview') @Watch('onPreviewThemeChange') themeStylePreview: boolean = false;
  @StorageProp('collaborationDataList') @Watch('updateLayoutParams') collaborationDataList: Array<DockItemInfo> = [];
  @StorageLink('screenWidth') @Watch('onScreenWidthChange') screenWidth: number =
    AppStorage.get<number>('screenWidth') as number;
  @StorageLink('screenHeight') screenHeight: number = AppStorage.get<number>('screenHeight') as number;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') isPortrait: boolean = true;
  @StorageLink('isContinueItemAnimating') isContinueItemAnimating: boolean = false;
  @StorageLink('dockHeight') dockHeight: number = 0;
  @Prop @Watch('onContinueChange') isContinueShow: boolean = false;
  @Prop @Watch('onItemsListChanged') itemsChangeFlag: number = 0;
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  @State animationVm: DockRegionAnimationVm = new DockRegionAnimationVm();
  private animationEvent: DockRegionAnimationEvent = new DockRegionAnimationEvent(this.animationVm);
  private onDesktopModeChangeEvent: Function = (): void => {
    log.showInfo(`onDesktopModeChangeEvent, region: ${this.region}`);
    this.updateLayoutParams();
  };
  private onMultiWindowExitEvent: Function = (): void => {
    log.showInfo(`onMultiWindowExitEvent, region: ${this.region}`);
    this.updateLayoutParams();
  };
  private onIconSizeChangeEvent: Function = (): void => {
    log.showInfo(`onIconSizeChangeEvent, region: ${this.region}`);
    this.updateLayoutParams();
  };
  private backPlaneChangeListener: (data: DockAvgColorChangeEvent) => void = (data: DockAvgColorChangeEvent) => {
    this.backPlaneBgColor = data.dockAvgColor;
  };
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();

  private onLayoutChanged(): void {
    this.layoutModel.updateRegionLayoutWidth(this.region, this.layoutWidth);
  }

  private onContinueChange(): void {
    log.showInfo(`onContinueChange, region: ${this.region}, isContinueShow: ${this.isContinueShow}`);
    animateTo({
      duration: SmartDockConstants.CONTINUABLE_ICON_SHOW_DURATION,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        this.isOnContinueItemDisappear = false;
      }
    }, () => {
      if (!this.isContinueShow && this.isContinueItemAnimating) {
        this.isContinueItemAnimating = false;
        AppStorage.setOrCreate('isContinueItemAnimating', false);
      }
      if (!this.isContinueShow) {
        this.isOnContinueItemDisappear = true;
      }
      this.refreshLayout();
    });
  }

  private onItemsListChanged(): void {
    log.showInfo(`onItemsListChanged, region: ${this.region}`);
    this.refreshLayout(true);
  }

  private onPortraitStatusChange(): void {
    log.showInfo(`onPortraitStatusChange update, region: ${this.region}`);
    this.updateLayoutParams();
  }

  private updateLayoutParams(): void {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      log.showInfo('pcMode, dont change');
      return;
    }

    this.refreshLayout();
  }

  private updateLayoutWidth(isNeedAnimation: boolean = false): void {
    let width = this.refreshHandler.calculateLayoutWidth();
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      width = this.layoutPropertyVm.calculateRegionWidth(this.items.length)
    }
    if (this.layoutWidth === width) {
      return;
    }
    log.showInfo(`updateLayoutWidth old width: ${this.layoutWidth}, new width: ${width}`)
    if (isNeedAnimation) {
      animateTo({
        duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
        curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
      }, (): void => {
        this.layoutWidth = width;
      })
    } else {
      this.layoutWidth = width;
    }
  }

  private onScreenWidthChange(): void {
    log.showInfo(`Screen width change, region: ${this.region}`)
    this.refreshLayout();
  }

  private refreshLayout(isNeedAnimation: boolean = false): void {
    this.items = this.refreshHandler.reloadItems();
    if(SmartDockZoomFeatureSwitch.isSupportZoom()){
      SmartDockZoomEvent.getInstance().onDockRefresh(this.region, this.items.length);
    }
    this.layoutPropertyVm.reloadLayoutProperties(this.items.length);
    this.updateLayoutWidth(isNeedAnimation);
    log.showInfo('refreshLayout, length: %{public}d, width: %{public}d, iconSize: %{public}d, space: %{public}d' +
      ', isPortrait: %{public}s', this.items?.length, this.layoutWidth, this.layoutPropertyVm.iconSize,
      this.layoutPropertyVm.space, this.isPortrait);
  }

  private onThemeChange(): void {
    log.showInfo(`Theme style change, region: ${this.region}`);
    this.refreshLayout();
  }

  private onPreviewThemeChange(): void {
    log.showInfo(`Preview theme style change, region: ${this.region}`);
    this.refreshLayout();
  }

  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_LOCK_STATE) {
        let isLocked = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
        ?.getSlState(SlStaticStateType.SL_LOCK_STATE) as boolean;
        log.showInfo(`ScbRecentLayout received slStaticStateListener isLocked is ${isLocked}`);
        if (isLocked) {
          this.residentOnLockReceived();
        }
      }
    }
  };

  residentOnLockReceived(): void {
    this.isLockReceived = true;
    this.isUnLockReceived = false;
  }

  private onUnlockStartSceneReceived(){
    this.animationEvent.setVisible(Visibility.Hidden);
  }

  residentOnUnLockReceived(): void {
    this.isUnLockReceived = true;
    this.isLockReceived = false;
    this.animationEvent.setVisible(Visibility.Visible);
    HiDfxEventUtil.reportUnlockToDesktop(HiDfxEventUtil.UNLOCK_TO_DOCK_ANIMATION_BEGIN, CommonConstants.INVALID_VALUE);
  }

  private registerUnlockTransitionController(): void {
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  // fold screen animation
  private expandedAnimation(): void {
    log.showInfo(`recent execute expandedAnimation, region: ${this.region}`);
    this.isDragIng = false;
    this.animationEvent.expandedAnimation(this.screenWidth, this.layoutWidth, this.getDividerId(), false);
  }

  private tripleAnimationListener = (event: RecentDockAnimationEvent) => {
    this.tripleAnimation(event.lastTripleFoldState, event.curTripleFoldState);
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState): void {
    log.showInfo('recent dock bg execute tripleAnimation, oldState is %{public}d, newState is %{public}d',
      oldState, newState);
    let stateChange: SCBTripleStateChange = TripleFoldExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX =
        TripleFoldExpandAnimUtils.initTripleDockAnimTranslateX(this.screenWidth, stateChange);
      this.animationVm.alpha = TripleFoldExpandAnimUtils.initTripleDockBgAnimAlpha(stateChange);
    });
    animateTo({
      curve: TripleFoldAnimationConstants.TRANSLATE_CURVES,
      duration: TripleFoldAnimationConstants.ANIMATION_DURATION,
    }, () => {
      this.animationVm.translateX = 0;
    });
    animateTo({
      curve: Curve.Linear,
      duration: TripleFoldAnimationConstants.DOCK_BG_ALPHA_DURATION,
    }, () => {
      this.animationVm.alpha = 1;
    });
  }

  private getDividerId(): string {
    return `DOCK_${this.region}_DIVIDER`;
  }

  private getBackgroundId(): string {
    return `DOCK_${this.region}_BG`;
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  private onScreenOn(): void {
    this.animationEvent.onScreenOn();
  }

  private onLockReceived(): void {
    log.showInfo('onLockReceived isLockReceived: ' + this.isLockReceived);
    if (!this.isLockReceived) {
      return;
    }
    this.animationEvent.lockAnimation(this.screenWidth, this.screenHeight, this.getBackgroundId());
  }

  private onUnLockReceived(): void {
    log.showInfo('onUnLockReceived isUnLockReceived: ' + this.isUnLockReceived);
    if (!this.isUnLockReceived) {
      return;
    }
    if (!(AppStorage.get<boolean>('shieldAnim') ?? false)) {
      this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight, this.getBackgroundId());
    }
  }

  private onScaleChange(): void {
    animateTo({
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
    }, (): void => {
      this.layoutWidth = this.layoutPropertyVm.calculateRegionWidth(this.items.length);
    })
  }

  aboutToAppear(): void {
    log.showInfo(`DockRegionLayout aboutToAppear, region:${this.region}`);
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo('hide the ScbRecentLayout for first enter desktop');
      this.animationVm.visible = Visibility.Hidden;
    }
    this.refreshLayout();
    this.registerUnlockTransitionController();
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.expandController = {
      itemId: `${TAG}_recent`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      EvtBus.on<RecentDockAnimationEvent>(RecentDockAnimationEvent, this.tripleAnimationListener);
    }
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.on(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    EvtBus.on(DockAvgColorChangeEvent, this.backPlaneChangeListener);
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToDisappear(): void {
    log.showInfo(`DockRegionLayout aboutToDisappear, region:${this.region}`);
    this.layoutModel.updateRegionLayoutWidth(this.region, 0);
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      EvtBus.off<RecentDockAnimationEvent>(RecentDockAnimationEvent, this.tripleAnimationListener);
    }
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT,
      this.onMultiWindowExitEvent);
    this.desktopContext?.eventHub.off(SmartDockConstants.ICON_SIZE_CHANGE_EVENT, this.onIconSizeChangeEvent);
    EvtBus.off(DockAvgColorChangeEvent, this.backPlaneChangeListener);
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  @Builder
  dividerBuilder() {
    Column() {
      Divider()
        .vertical(true)
        .color(SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.DOCK_BLUR_DISABLE) ? this.backPlaneBgColor :
        $r('app.color.dock_divider_color'))
        .strokeWidth(SmartDockConstants.RECENT_DOCK_DIVIDER_WIDTH)
        .height(SmartDockConstants.RECENT_DOCK_DIVIDER_HEIGHT)
        .width(this.layoutPropertyVm.dividerWidth)
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .margin({
          top: (this.layoutPropertyVm.dockHeight - SmartDockConstants.RECENT_DOCK_DIVIDER_HEIGHT) /
          NumberConstants.CONSTANT_NUMBER_TWO
        })
        .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
        .scale({
          x: this.animationVm.dividerScale,
          y: this.animationVm.dividerScale,
          centerX: this.animationVm.centerX,
          centerY: this.animationVm.centerY,
        })
        .opacity(this.animationVm.alpha)
        .visibility(this.animationVm.visible)
        .lineCap(LineCapStyle.Round)
        .id(this.getDividerId())
        .onTouch((event?: TouchEvent) => {
          this.animationEvent.onDividerTouch(event);
        })
        .priorityGesture(
          PanGesture({ distance: 0 })
            .onActionStart((event?: GestureEvent) => {
              if (event && this.dividerDragEvent) {
                //中间值记录起始宽度
                this.lastLayoutWidth = this.layoutWidth;
                this.isDragIng = true;
                log.showInfo(`onActionStart set isDragIng is true`);
              }
            })
            .onActionUpdate((event?: GestureEvent) => {
              if (DeviceHelper.isPad() && SmartDockZoomFeatureSwitch.isSupportZoom()) {
                return;
              }
              if (event && this.dividerDragEvent) {
                const offsetX = event.offsetX;
                this.isDragIng = true;
                let curRecentLayoutWidth: number =
                  RTLUtil.isRTL() ? this.lastLayoutWidth + offsetX : this.lastLayoutWidth - offsetX;
                if (curRecentLayoutWidth <= SmartDockConstants.RECENT_DOCK_EDGE_BLUR_WIDTH * 2) {
                  this.layoutWidth = SmartDockConstants.RECENT_DOCK_EDGE_BLUR_WIDTH * 2;
                } else {
                  //向左拉长超过图标数量时增加阻尼曲线 y=x−0.25𝑥^2的导数1 -0.5𝑥
                  let maxWidth: number = this.dividerDragEvent.onActionUpdate(event);
                  if (maxWidth <= curRecentLayoutWidth && (1 - 0.5 * Math.abs(event.offsetX) <= 0)) {
                    this.layoutWidth = maxWidth;
                  } else {
                    //正常拉长
                    this.layoutWidth = curRecentLayoutWidth;
                  }
                }
              }
            })
            .onActionEnd((event?: GestureEvent) => {
              if (DeviceHelper.isPad() && SmartDockZoomFeatureSwitch.isSupportZoom()) {
                return;
              }
              if (event && this.dividerDragEvent) {
                //松手逻辑计算
                const layoutWidthUp = this.dividerDragEvent.onActionEnd(this.layoutWidth, event);
                animateTo({
                  curve: curves.springCurve(1.5, 1.5, 230, 25),
                  onFinish: () => {
                    this.isDragIng = false;
                    log.showInfo(`onActionEnd set isDragIng is false`);
                  }
                }, () => {
                  this.layoutWidth = layoutWidthUp;
                })
              }
            })
        )
    }
    .width(this.layoutPropertyVm.dividerWidth)
    .height(SmartDockConstants.PERCENTAGE_100)
    .borderRadius(this.layoutPropertyVm.dockRadius)
    .align(Alignment.Top)
    .offset({
      top: this.smartDockStyleConfig.mDockHeight - this.layoutPropertyVm.dockHeight
    })
  }

  build() {
    Row() {
      if (this.region === DockRegionType.RECENT) {
        this.dividerBuilder();
      }

      Stack() {
        BackPlane({
          mDockHeight: this.layoutPropertyVm.dockHeight,
          mDockRadius: this.layoutPropertyVm.dockRadius,
          backPlaneWidth: this.layoutWidth + this.recentLayoutAdditionWidth,
          backPlaneId: this.getBackgroundId(),
          backPlaneTranslate: { x: this.animationVm.translateX, y: this.animationVm.translateY },
          backPlaneScale: {
            x: this.animationVm.scaleSizeX,
            y: this.animationVm.scaleSizeY,
            centerX: this.animationVm.isUnlocking ? this.animationVm.centerX : '100%',
            centerY: this.animationVm.centerY,
          },
          backPlaneOpacity: this.animationVm.alpha,
          backPlaneVisibility: this.animationVm.visible,
          backPlaneBlur: this.animationVm.blurRadius,
          backPlaneUseEffect: true
        })

        List({ space: this.layoutPropertyVm.space }) {
          ForEach(this.items, (item: DockItemInfo, index) => {
            DockAppItem({
              appInfo: item,
              singleContext: this.singleContext,
              index: index,
              items: this.items,
              region: this.region,
              buildMenu: this.buildMenu,
              isUnLockReceived: $isUnLockReceived,
              isLockReceived: $isLockReceived,
              smartDockStyleConfig: this.smartDockStyleConfig,
              isContinueItemAnimating: this.isContinueItemAnimating,
              iconSize: this.layoutPropertyVm.iconSize,
              deviceType: this.deviceType,
              itemOnClick: (appItem: DockItemInfo, event?: ClickEvent) => {
                if (editModeManager.isInEditMode()) {
                  return;
                }
                if (this.onItemClick) {
                  this.onItemClick(event, appItem);
                }
              }
            })
          }, (item: DockItemInfo, index: number) => {
            let thStyleKey = this.themeStyle + this.desktopIconChange;
            const itemKey = `${item.keyName}_${thStyleKey}_`;
            const appKey = itemKey + `${item.installTime}_${item.appIconId}_${item.iconType}`;
            return appKey;
          })
        }
        .alignListItem(ListItemAlign.Center)
        .clip(this.isDragIng || this.isOnContinueItemDisappear)
        .enableScrollInteraction(false)
        .width(SmartDockConstants.PERCENTAGE_100)
        .height(this.layoutPropertyVm.dockHeight)
        .contentStartOffset(this.layoutPropertyVm.listPadding)
        .animation({
          duration: SmartDockConstants.CONTINUABLE_ICON_SHOW_DURATION,
          curve: Curve.Friction
        })
        .listDirection(this.smartDockStyleConfig.mListDirection)
        .editMode(true)
        .scrollBar(BarState.Off)
        .borderRadius(this.layoutPropertyVm.dockRadius)
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
          if (scrollSource === ScrollSource.OTHER_USER_INPUT) {
            scrollOffset = 0;
          }
          let res: ScrollResult = { offsetRemain: scrollOffset };
          return res;
        })
        .visibility(this.animationVm.visible)
      }
      .clip(CommonConstants.DEFAULT_CLIP_FALSE)
      .borderRadius(this.layoutPropertyVm.dockRadius)
      .alignContent(Alignment.Top)
      .offset({
        top: this.smartDockStyleConfig.mDockHeight - this.layoutPropertyVm.dockHeight
      })
      .width(this.layoutWidth + this.recentLayoutAdditionWidth)
      .height(SmartDockConstants.PERCENTAGE_100)
      .visibility(this.layoutWidth === 0 ? Visibility.None : Visibility.Visible)
      .foregroundEffect({ radius: this.animationVm.blurRadius })

      if (this.region === DockRegionType.COLLABORATION) {
        this.dividerBuilder();
      }
    }
    .clip(CommonConstants.DEFAULT_CLIP_FALSE)
    .height(SmartDockConstants.PERCENTAGE_100)
    .width(this.layoutWidth + this.layoutPropertyVm.dividerWidth + this.recentLayoutAdditionWidth)
    .hitTestBehavior(HitTestMode.Default)
    .zIndex(-1)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }
}