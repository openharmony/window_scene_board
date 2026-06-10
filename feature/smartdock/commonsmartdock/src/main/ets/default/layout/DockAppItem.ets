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

import { LogDomain, Logger, StartType, SingleContext } from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  ResourceManager,
  ScreenState,
  ViewCallback,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { SCBExpandController, SCBTransitionManager } from '@ohos/windowscene';
import {
  AppDataWrapper,
  DesktopUtils,
  DockContinuableInfo,
  DockItemInfo,
  DockUtils,
  HiSysContinueFuncResult,
  layoutConfigManager,
  MenuInfo,
  SCBHiSysEventUtil
} from '@ohos/launchercommon';
import {
  AppIconCommonEvent,
  AppIconCommonView,
  AppIconConfig,
  AppIconDefaultModifier,
  AppNameVm,
  BadgeAnimationType
} from '@ohos/launchercommon/Index';
import curves from '@ohos.curves';
import type ctx from '@ohos.app.ability.common';
import { AppIconMenuVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconMenuVm';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { PageDesktopDragHandler } from '@ohos/pagedesktop';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { CommonModifier, LengthMetrics } from '@kit.ArkUI';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import { DockItemAnimationVm } from '../viewmodel/DockItemAnimationVm';
import { DockItemAnimationEvent } from '../viewmodel/DockItemAnimationEvent';
import {
  GravityAnimationComponent,
  gravityAnimationManager,
  GravityAnimationPage,
  GravityAnimationParameter
} from '@ohos/componentanimator/Index';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import lazy {
  SCBTripleStateChange,
  UltraScreenExpandAnimUtils,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import lazy {
  UltraScreenAnimationConstants
} from '@ohos/launchercommon/src/main/ets/constants/UltraScreenAnimationConstants';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import lazy { RecentDockAnimationEvent } from '@ohos/launchercommon/src/main/ets/events/RecentDockEvents';
import { DockRegionLayoutPropertyVm } from '../viewmodel/DockRegionLayoutPropertyVm';
import { SmartDockObserver } from '../viewmodel/smartDockObserver';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import {
  AppIconActiveEventIface
} from '@ohos/launchercommon/src/main/ets/launchericon/interface/AppIconActiveEventIface';

const TAG = 'SmartDock_V_DockAppItem';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

@Component
export struct DockAppItem {
  buildMenu?: Function;
  @Prop singleContext?: SingleContext;
  itemOnClick: Function = (item: DockItemInfo, event: ClickEvent) => {
  };
  private smartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  private expandController?: SCBExpandController;
  private deviceType: string = '';
  private region: DockRegionType = DockRegionType.RECENT;
  private appIconConfig: AppIconConfig = new AppIconConfig();
  @Link items: Array<DockItemInfo>;
  @Prop iconSize: number = 0;
  @Prop isContinueItemAnimating: boolean = false;
  @State appInfo: DockItemInfo = new DockItemInfo();
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State index: number = 0;
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  @State layoutPropertyVm: DockRegionLayoutPropertyVm = SmartDockObserver.getInstance().getLayoutPropertyVm();
  @State continueBadgeVisible: boolean = true;
  @Link @Watch('onUnLockReceived') isUnLockReceived: boolean;
  @Link @Watch('onLockReceived') isLockReceived: boolean;
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State modifier?: FocusAbleModifier = new FocusAbleModifier();
  @State animationVm: DockItemAnimationVm = new DockItemAnimationVm();
  private animationEvent: DockItemAnimationEvent = new DockItemAnimationEvent(this.animationVm);
  private gravity: GravityAnimationComponent | null = null;
  private appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
  private iconModifier: AppIconDefaultModifier = new AppIconDefaultModifier();
  private appIconMenuVm = new AppIconMenuVm();
  private appNameVm: AppNameVm = new AppNameVm();
  private desktopContext: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private onScaleChangeEvent: (index: number) => void = () => this.onScaleChange();
  private appIconActiveEvent: AppIconActiveEventIface = {
    useDefaultIconShow: true,
    onActive: (): void => {
      this.continueBadgeVisible = false;
      log.showInfo(TAG, 'onActive');
    },
    onInactive: (): void => {
      this.continueBadgeVisible = true;
      log.showInfo(TAG, 'onInActive');
    }
  }

  // fold screen animation
  private expandedAnimation(): void {
    this.animationEvent.expandedAnimation(this.screenWidth, this.screenHeight,
      DockUtils.getDockItemId(this.appInfo, this.region), this.index, false);
  }

  private tripleAnimationListener = (event: RecentDockAnimationEvent) => {
    this.tripleAnimation(event.lastUltraScreenState, event.curUltraScreenState);
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState): void {
    log.showInfo(TAG, `recent dock item execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    let stateChange: SCBTripleStateChange = UltraScreenExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    let col: number[] = UltraScreenExpandAnimUtils.getTripleDockColumn(this.index, false);
    animateTo({
      duration: 0,
    }, () => {
      this.animationVm.translateX =
        UltraScreenExpandAnimUtils.initTripleDockAnimTranslateX(this.screenWidth, stateChange);
      this.animationVm.alpha = UltraScreenExpandAnimUtils.initTripleRecentDockItemAnimAlpha(stateChange);
    });
    animateTo({
      curve: UltraScreenAnimationConstants.TRANSLATE_CURVES,
      duration: UltraScreenAnimationConstants.ANIMATION_DURATION,
    }, () => {
      this.animationVm.translateX = 0;
    });
    let alphaDelayTime: number = UltraScreenExpandAnimUtils.getUltraScreenExpandAlphaDelayTime(col[0], stateChange);
    animateTo({
      curve: Curve.Linear,
      delay: alphaDelayTime,
      duration: UltraScreenAnimationConstants.ALPHA_DURATION,
    }, () => {
      this.animationVm.alpha = 1;
    });
  }

  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };

  private onScreenOff(): void {
    this.isUnLockReceived = false;
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  // 此次修改和需要this.visible协同
  private onScreenOn(): void {
    this.animationEvent.onScreenOn();
  }

  private onLockReceived() {
    if (!this.isLockReceived) {
      return;
    }
    log.showInfo(TAG, 'AppItem onLockReceived' + this.isLockReceived);
    this.animationEvent.lockAnimation(this.screenWidth, this.screenHeight,
      DockUtils.getDockItemId(this.appInfo, this.region));
  }

  private onUnLockReceived() {
    if (this.isUnLockReceived === false) {
      return;
    }
    log.showInfo(TAG, 'AppItem onUnLockReceived' + this.isUnLockReceived);
    this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight,
      DockUtils.getDockItemId(this.appInfo, this.region));
  }

  private initAppIconConfig(): void {
    this.appIconConfig
      .setEnableNameAnim(false)
      .setEnableDrag(false)
      .setEnableBackplane(false)
      .setEnableHoverAnimation(true)
      .setAppDataOfTransactionController(AppDataWrapper.getDefaultAppData(this.appInfo,
        this.smartDockStyleConfig.mIconRadius)
        .setExtraId(String(this.appInfo.appIconId))
        .setStartType(StartType.RECENT_DOCK_APP))
      .setIsDesktopItem(false)
      .setKeepMenuOrder(true)
      .setExternCb({
        getMenuInfo: (): MenuInfo[] => {
          return this.initMenuInfo();
        },
        onMenuDisappear: (isLongPressShow: boolean) => {
          animateTo({
            duration: 0,
          }, () => {
            this.animationVm.alpha = 1;
          })
        },
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          this.itemOnClick(this.appInfo, event);
        },
        onMenuDragStart: (x: number, y: number): void => PageDesktopDragHandler.getInstance(this.singleContext).onDragStart(x, y)
      });
    // 预览图底部margin设置为0，防止菜单生成时组件位置突变
    // dock在屏幕底端，下方设置有24vp的安全间隔，由于与导航条间隔太近，会使预览图生成的时候往上偏，预期是菜单原地生成，因此将该属性设为0
    this.appIconMenuVm.setLayoutRegionMargin({ bottom: 0 });
  }


  private getIndex(): number {
    return this.items.findIndex((item) => item.keyName === this.appInfo.keyName);
  }

  private getVisibleCount(): number {
    if (this.region === DockRegionType.RECENT) { // 最近任务区实际显示多少个图标和visibleCount相关
      const visibleCount = AppStorage.get<number>('visibleCount') ?? 0;
      return visibleCount === 0 ? this.items.length : Math.min(this.items.length, visibleCount);
    }
    return this.items.length;
  }

  private registerGravityAnimation(): void {
    const index = this.getIndex();
    const count = this.getVisibleCount();
    const centerX = SmartDockStyleMgr.getInstance().getDockItemCenterXByRegion(count, index, this.region);
    const centerY = SmartDockStyleMgr.getInstance().getDockItemCenterY();
    log.showInfo('create dock-item gravity animation with region: %{public}s, id: %{public}s, index: %{public}d' +
      ', x: %{public}d, y: %{public}d', this.region, this.appInfo.keyName, index, centerX, centerY);
    this.gravity = new GravityAnimationComponent(
      (param: GravityAnimationParameter) => {
        this.animationEvent.startGravityAnimation(param, this.appInfo);
      },
      () => {
        this.updatePosition();
      });
    this.gravity.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 1, index, 1, 1);
    this.gravity.setPosition(centerX, centerY);
    this.gravity.setActive(true);
    gravityAnimationManager.addComponent(this.gravity);
  }

  private unregisterGravityAnimation(): void {
    if (this.gravity) {
      gravityAnimationManager.removeComponent(this.gravity);
      this.gravity = null;
    }
  }

  private updatePosition(): void {
    if (this.gravity) {
      const index = this.getIndex();
      const count = this.getVisibleCount();
      const centerX = SmartDockStyleMgr.getInstance().getDockItemCenterXByRegion(count, index, this.region);
      const centerY = SmartDockStyleMgr.getInstance().getDockItemCenterY();
      log.showInfo('update dock-item gravity animation with region: %{public}s, id: %{public}s, index: %{public}d' +
        ', x: %{public}d, y: %{public}d', this.region, this.appInfo.keyName, index, centerX, centerY);

      this.gravity.setLayoutInfo(GravityAnimationPage.FOREVER_TRIGGER, 1, index, 1, 1);
      this.gravity.setPosition(centerX, centerY);
    }
  }

  private onScaleChange(): void {
    this.iconBadgeVm.ratio = this.layoutPropertyVm.scale;
  }

  aboutToAppear(): void {
    this.initAppIconConfig();
    log.showDebug(TAG, `aboutToAppear: appInfo: ${this.appInfo?.bundleName}`);
    this.iconBadgeVm.ratio = DockRegionLayoutModel.getInstance().getScale();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.expandController = {
      itemId: `${TAG}_recent`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      EvtBus.on<RecentDockAnimationEvent>(RecentDockAnimationEvent, this.tripleAnimationListener);
    }
    this.desktopContext?.eventHub.on(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
    this.appIconCommonEvent.setIconActiveEvent(this.appIconActiveEvent);
  }

  aboutToDisappear(): void {
    log.showDebug(TAG, `aboutToDisappear: appInfo: ${this.appInfo?.bundleName}`);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      EvtBus.off<RecentDockAnimationEvent>(RecentDockAnimationEvent, this.tripleAnimationListener);
    }
    this.desktopContext?.eventHub.off(SmartDockConstants.DOCK_ZOOM_EVENT, this.onScaleChangeEvent);
  }

  aboutToReuse(param: Record<string, object>): void {
    this.appInfo = param.appInfo as DockItemInfo;
    this.isUnLockReceived = Boolean(param.isUnLockReceived);
  }

  aboutToRecycle(): void {
    this.appInfo = new DockItemInfo();
  }

  private initMenuInfo(): MenuInfo[] {
    let menuInfo: MenuInfo[] = this.buildMenu?.(this.appInfo);
    log.showInfo(TAG, `initMenuInfo length: ${menuInfo.length}, bundleName is:${this.appInfo.bundleName}`);
    return menuInfo;
  }

  private getScaleOptions(): ScaleOptions {
    return {
      x: this.animationVm.scaleSize,
      y: this.animationVm.scaleSize,
      centerX: this.animationVm.centerX,
      centerY: this.animationVm.centerY,
    };
  }

  @Builder
  appIconBuilder() {
    AppIconCommonView({
      item: this.appInfo,
      iconMenuVm: this.appIconMenuVm,
      appNameVm: this.appNameVm,
      appIconConfig: this.appIconConfig,
      iconSize: this.iconSize,
      iconRadius: this.layoutPropertyVm.iconRadius,
      iconBadgeVm: this.iconBadgeVm,
      iconEvent: this.appIconCommonEvent,
      iconModifier: this.iconModifier,
      nameSize: 0
    })
  }

  build() {
      ListItem() {
        this.appIconBuilder()
      }
      .onClick(this.isAccessibilityMode ? (event) => {
        this.itemOnClick(this.appInfo, event);
      } : undefined)
      .onAccessibilityHover((isHover, event) => {
        if (!isHover) {
          return;
        }
        if (AppStorage.get<boolean>('hadFocusDock')) {
          this.appNameVm.modifier.attribute?.accessibilityText(this.appInfo.appName);
          return;
        }
        this.appNameVm.modifier.attribute?.accessibilityText(ResourceManager.getInstance()
          .getStringByName('accessibility_dock') + ',' + this.appInfo.appName);
        AppStorage.setOrCreate<boolean>('hadFocusDock', true);
        AppStorage.setOrCreate<string>('accessibility_dock', '');
      })
      .accessibilityDescription(DesktopUtils.getAccessibilityDescription(this.isAccessibilityMode,
        false, this.appInfo))
      .foregroundEffect({ radius: this.animationVm.blurRadius })
      .id(DockUtils.getDockItemId(this.appInfo, this.region))
      .zIndex(1)
      .width(this.iconSize)
      .height(this.iconSize)
      .backgroundColor(this.smartDockStyleConfig.mItemBackgroundColor)
      .borderRadius(this.smartDockStyleConfig.mItemBorderRadius)
      .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
      .scale(this.getScaleOptions())
      .opacity(this.animationVm.alpha)
      .transition(TransitionEffect.IDENTITY)
      .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.None : HitTestMode.Default)
      .draggable(false)
      .visibility(this.animationVm.visible)
      .attributeModifier(this.modifier)
    }
}

class FocusAbleModifier extends CommonModifier {
  private isAble: boolean = true;

  public setIsAble(value: boolean) {
    this.isAble = value;
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    instance.focusable(this.isAble);
    super.applyNormalAttribute?.(instance);
  }
}