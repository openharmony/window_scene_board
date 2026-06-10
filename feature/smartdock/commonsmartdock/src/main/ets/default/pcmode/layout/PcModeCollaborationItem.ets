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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { GlobalContext, IconResourceManager } from '@ohos/frameworkwrapper';
import { DockItemInfo, GridLayoutUtil, layoutConfigManager,
  MenuInfo,
  RecentBundleMissionInfo,
  SmartDockStyleConfig,
  AppModel,
  StyleConstants} from '@ohos/launchercommon';
import CollaborationItem from '../../layout/CollaborationItem';
import { AppMenu, RunningTask } from '@ohos/launchercommon/Index';
import FeatureConstants from '../../common/constants/FeatureConstants';
import { ScrollerComponent } from '../../layout/ScrollerComponent';
import { DockItemAnimationVm } from '../../viewmodel/DockItemAnimationVm';
import { DockRegionLayoutPropertyVm } from '../../viewmodel/DockRegionLayoutPropertyVm';
import SmartDockViewModel from '../../viewmodel/SmartDockViewModel';
import { PcModeMenuEvent, PcModePopupEvent } from '../viewmodel/PcModeMenuAndPopupEvent';
import { PcModeMenuVm, PcModePopupVm } from '../viewmodel/PcModeMenuAndPopupVm';
import { DockItemAnimationEvent } from '../../viewmodel/DockItemAnimationEvent';

const TAG = 'PcModeCollaborationItem';

@Component
export struct PcModeCollaborationItem {
  smartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  @State appInfo: DockItemInfo = new DockItemInfo();
  @Link @Watch('onUnLockReceived') isUnLockReceived: boolean;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @Link layoutPropertyVm: DockRegionLayoutPropertyVm;
  @State animationVm: DockItemAnimationVm = new DockItemAnimationVm();
  private animationEvent: DockItemAnimationEvent = new DockItemAnimationEvent(this.animationVm);
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') screenHeight: number = 0;
  @State menuVm: PcModeMenuVm = new PcModeMenuVm();
  @State popupVm: PcModePopupVm = new PcModePopupVm();
  @State isUnLocking: boolean = false;
  private popupEvent: PcModePopupEvent = new PcModePopupEvent(this.popupVm, this.menuVm);
  private menuEvent: PcModeMenuEvent = new PcModeMenuEvent(this.menuVm, this.popupVm, this.animationVm);

  private onUnLockReceived(): void {
    if (this.isUnLockReceived === false) {
      return;
    }
    this.isUnLocking = true;
    this.animationEvent.unlockAnimation(this.screenWidth, this.screenHeight, this.getId(),
      () => this.isUnLocking = false);
  }

  private getId(): string {
    return `${TAG}_${this.appInfo.bundleName}_icon`;
  }

  private isSyncLoad(resource: string | PixelMap): boolean {
    return (typeof resource !== 'string') || GridLayoutUtil.isImageSyncLoad(resource);
  }

  private getBinaryHeight(): number {
    return (this.layoutPropertyVm.dockHeight - this.layoutPropertyVm.iconSize) / 2;
  }

  private getContextMenu(): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_EIGHT },
      placement: Placement.TopLeft,
      backgroundBlurStyle: BlurStyle.NONE,
      preview: () => { this.AppPixmapCreator() },
      layoutRegionMargin: { bottom: 0 },
      aboutToAppear: () => this.menuEvent.onMenuAppear(),
      onDisappear: () => this.menuEvent.onMenuDisappear()
    };
  }

  private getMenuInfoList(): MenuInfo[] {
    const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
    const missionInfo = missionInfoList?.find(info => info.bundleName === this.appInfo?.bundleName);
    return !CheckEmptyUtils.isEmpty(missionInfo)
      ? [SmartDockViewModel.getInstance().getExitMenu(this.appInfo)]
      : [SmartDockViewModel.getInstance().getOpenMenu(this.appInfo)];
  }

  private updateIconImage(): string | PixelMap {
    return this.appInfo.iconResource ? this.appInfo.iconResource : IconResourceManager.getInstance()
      .getCachedCombIconSync(this.appInfo.bundleName, this.appInfo.moduleName as string, this.appInfo.abilityName);
  }

  private onActive = (): void => {
    this.menuVm.badgeVisible = false;
  }

  private onInactive = (): void => {
    this.menuVm.badgeVisible = true;
  }

  aboutToAppear(): void {
    this.popupEvent.init(this.appInfo);
  }

  aboutToDisappear(): void {
    this.popupEvent.destroy(this.appInfo);
  }

  @Builder AppPixmapCreator() {
    Stack() {
      Image(this.updateIconImage())
        .draggable(false)
        .width(this.layoutPropertyVm.iconSize)
        .height(this.layoutPropertyVm.iconSize)
        .borderRadius(this.layoutPropertyVm.iconRadius)
        .syncLoad(this.isSyncLoad(this.updateIconImage()))
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
    }
  }

  @Builder MenuBuilder() {
    AppMenu({
      menuInfoList: this.getMenuInfoList(),
      menuWidth: StyleConstants.MENU_WIDTH_COLUMNS_PHONE,
      iconSize: this.layoutPropertyVm.iconSize,
      iconRadius: this.layoutPropertyVm.iconRadius,
    })
  }

  @Builder popupBuilder(item: DockItemInfo) {
    ScrollerComponent({
      mPopItem: item,
      updateData: (show: boolean, bundleName: string, callback: Callback<void>) =>
      this.popupEvent.updatePopupData(item, show, bundleName, callback),
      popupHide: () => this.popupEvent.popupHide()
    })
  }

  @Styles
  eventStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_HIDE_BADGE })
          .onAction((event: GestureEvent) => {
            if (event?.source === SourceType.TouchScreen) {
              this.menuEvent.setMenuShowStatus(true);
              this.menuVm.badgeVisible = false;
            }
          })
      )
    )
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.menuEvent.onTouchDown();
      } else if (event.type === TouchType.Up) {
        this.menuEvent.onTouchUp();
      }
    })
  }

  build() {
    Column() {
      CollaborationItem({
        appInfo: this.appInfo,
        isContinueItemAnimating: true,
        collaborationBadgeVisible: this.menuVm.badgeVisible,
        iconWidth: this.layoutPropertyVm.iconSize,
        iconHeight: this.layoutPropertyVm.iconSize,
        iconBackGroundColor: this.smartDockStyleConfig.mItemBackgroundColor,
        iconRadius: this.layoutPropertyVm.iconRadius,
        deviceType: this.appInfo.remoteDeviceTypeStr,
        isSupportHoverAnimation: true,
        isUnLockReceived: $isUnLockReceived,
        animationVm: this.animationVm,
        onActiveCallBack: this.onActive,
        onInactiveCallBack: this.onInactive
      }) // column高度比图标高, bindContextMenu放到column上显示位置有问题
        .bindContextMenu(this.MenuBuilder, ResponseType.RightClick, this.getContextMenu())
        .bindContextMenu(this.menuVm.isMenuShow, this.MenuBuilder, this.getContextMenu())
        .translate({ x: this.animationVm.translateX, y: this.animationVm.translateY })
        .scale({
          x: this.animationVm.scaleSize,
          y: this.animationVm.scaleSize,
          centerX: this.animationVm.centerX,
          centerY: this.animationVm.centerY
        })
        .opacity(this.animationVm.alpha)
        .id(AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon',
          this.appInfo?.bundleName, this.appInfo?.abilityName, this.appInfo?.appIndex, this.appInfo?.appInstanceKey))

      RunningTask({
        appInfo: this.appInfo,
        currColorMode: this.currColorMode,
        ratio: this.layoutPropertyVm.scale
      })
        .height(this.getBinaryHeight())
        .padding({ top: StyleConstants.DEFAULT_5 * this.layoutPropertyVm.scale })
        .visibility(this.isUnLocking ? Visibility.Hidden : Visibility.Visible)
    }
    .id(this.getId())
    .eventStyles()
    .bindPopup(this.popupVm.isPopupShow && this.popupEvent.popupShowJudge(this.appInfo), {
      builder: this.popupBuilder(this.appInfo),
      placement: Placement.Top,
      mask: false,
      enableArrow: true,
      autoCancel: true,
      onStateChange: (e) => this.popupEvent.onItemPopupStateChange(e.isVisible, this.appInfo),
      showInSubWindow: true,
      offset: { x: 0, y: -this.getBinaryHeight() },
      radius: StyleConstants.DEFAULT_8,
      shadow: ShadowStyle.OUTER_DEFAULT_SM,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
    })
    .margin({ top: this.getBinaryHeight() })
  }
}