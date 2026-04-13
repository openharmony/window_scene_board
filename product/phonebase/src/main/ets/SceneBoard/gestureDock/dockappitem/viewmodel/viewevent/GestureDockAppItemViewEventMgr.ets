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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { EventType, scbEventExclusiveManager, SCBTransitionManager } from '@ohos/windowscene';
import curves from '@ohos.curves';
import { AppDataWrapper, CommonConstants, vibratorMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DockType, GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockEventIdUtil } from '../../../common/util/GestureDockEventIdUtil';
import GestureDockAppItemViewDataMgr from '../viewdata/GestureDockAppItemViewDataMgr';
import { DockAppItemParam } from '../viewdata/GestureDockAppItemParam';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import GestureDockItemDragHandler from '../../../dockbar/viewmodel/viewhandler/GestureDockItemDragHandler';
import {
  AppIconLongPressGestureEventIface,
  AppIconGestureJudgeIface,
  AppIconDragEventIface
} from '@ohos/launchercommon/Index';

import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { DockAppItemConstants } from '../../model/DockAppItemConstants';

const TAG = 'GestureDockAppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAppItemViewEventMgr
 */
export default class GestureDockAppItemViewEventMgr {
  public viewDataMgr: GestureDockAppItemViewDataMgr;
  public appItemParam: DockAppItemParam;

  /**
   * 构造器
   *
   * @param viewDataMgr
   */
  public constructor(viewDataMgr: GestureDockAppItemViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.appItemParam = this.viewDataMgr.appItemParam;
  }

  aboutToAppear(): void {
    this.initAppIconConfig();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    this.viewDataMgr.expandController = {
      itemId: `${TAG}_recent`,
      onExpandAnimation: () => {
      },
    };
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.viewDataMgr.expandController);
    this.registerEventhub();
    this.updateItemOpacity();
  }

  aboutToDisappear(): void {
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.viewDataMgr.expandController);
    this.unRegisterEventhub();
  }

  deleteImageClick(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK)) {
      log.showInfo(`gesture dock item is dragged, can not delete.`);
      return;
    }
    animateTo({
      duration: GestureDockConstants.GESTURE_DOCK_SCALE_ANIMATE_TIME,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
        let index = residentApps.findIndex((itemInfo) => {
          return GestureDockUtil.areTwoAppItemsSame(itemInfo, this.viewDataMgr.gestureDockItemInfo);
        });
        log.showInfo(`onClick index is ${index}`);
        this.viewDataMgr.desktopContext?.eventHub.emit(GestureDockConstants.GESTURE_DOCK_DELETE_ITEM, index);
      }
    }, () => {
      this.appItemParam.scaleSize = GestureDockConstants.GESTURE_DOCK_SCALE;
    });
    animateTo({
      duration: GestureDockConstants.GESTURE_DOCK_OPACITY_ANIMATE_TIME,
      curve: Curve.Sharp,
      playMode: PlayMode.Normal,
    }, () => {
      this.appItemParam.alpha = 0;
    })
  }

  private startSqueezeEvent = (center: number): void => this.dockItemMoveAnimation(center);

  private dropEvent = (dragBundleName: string): void => this.dockItemDropAnimation(dragBundleName);

  private cancelSqueezeEvent: Function = (): void => {
    log.showInfo(`cancel bundleName is ${this.viewDataMgr.gestureDockItemInfo.bundleName}`);
    this.appItemParam.translateY = 0;
  };

  private dockItemVisible = (isVisible: boolean) => {
    log.showInfo(`dockItem visible bundleName is ${this.viewDataMgr.gestureDockItemInfo.bundleName}`);
    if (isVisible) {
      this.appItemParam.visible = Visibility.Visible;
    }
  }

  private updateItemOpacity = () => {
    if (this.appItemParam.alpha !== 1) {
      log.showInfo(`updateItemOpacity alpha:%{public}d bundleName:%{public}s`, this.appItemParam.alpha,
        this.viewDataMgr.gestureDockItemInfo.bundleName);
      return;
    }
    this.appItemParam.iconOpacity = this.viewDataMgr.getOpacity();
  }

  private deleteAppEvent = (index: number) => {
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let currentIndex = residentApps.findIndex((gestureDockItemInfo) => {
      return GestureDockUtil.areTwoAppItemsSame(gestureDockItemInfo, this.viewDataMgr.gestureDockItemInfo);
    });
    if (currentIndex < index) {
      log.showInfo(`no need to translate`);
    } else {
      let dockBarViewData = this.viewDataMgr.dockBarViewModel.getViewData();
      if (dockBarViewData) {
        this.appItemParam.translateY = GestureDockConstants.GESTURE_DOCK_ICON_SIZE +
        GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE + dockBarViewData.getEndOffset();
      }
    }
    animateTo({
      curve: Curve.Friction,
      duration: 350,
      delay: Math.abs(index - currentIndex) * 16.67,
      onFinish: (() => {
        log.showInfo(`animate currenrtIndex ${currentIndex} translate`);
      })
    }, () => {
      this.appItemParam.translateY = 0;
    });
  };

  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };

  private onScreenOff(): void {
    log.showInfo('onScreenOff');
  }

  /**
   * ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
   */
  private onScreenOn(): void {
    log.showInfo(' onScreenOn');
    if (this.appItemParam.visible != Visibility.Visible) {
      log.showInfo(' Screen On and show SwiperPage and SmartDock');
      this.appItemParam.visible = Visibility.Visible;
    }
  }

  private dockItemDropAnimation(dragBundleName: string): void {
    if (dragBundleName.indexOf(this.viewDataMgr.gestureDockItemInfo.bundleName) !==
    GestureDockConstants.INVALID_VALUE) {
      this.appItemParam.visible = Visibility.Visible;
    }
  }

  private dockItemMoveAnimation(newCenterY: number): void {
    let oldCenterY: number = GestureDockConstants.INVALID_VALUE;
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    for (let index = 0; index < residentApps.length; index++) {
      let item = residentApps[index];
      if (GestureDockUtil.areTwoAppItemsSame(item, this.viewDataMgr.gestureDockItemInfo)) {
        let dockBarViewData = this.viewDataMgr.dockBarViewModel.getViewData();
        if (dockBarViewData) {
          oldCenterY = GestureDockItemDragHandler.getInstance().getGestureDockItemCenter(index,
            dockBarViewData.getScrollTranslate())[1];
        }
        log.showInfo(`moveItem, bundleName：${item.bundleName} appIndex：${item.appIndex} index:${index} oldCenterY:${oldCenterY}`);
        break;
      }
    }

    log.showInfo('dockItemMoveAnimationFunc bundleName: %{public}s, appIndex: %{public}d, oldCenterX: %{public}d, newCenterX: %{public}d,' +
      'translateY is %{public}d', this.viewDataMgr.gestureDockItemInfo.bundleName,
      this.viewDataMgr.gestureDockItemInfo.appIndex, oldCenterY, newCenterY,
      this.appItemParam.translateY);

    // 原始位置获取异常、目标位置无效及两者位置一致时不执行动效
    if (oldCenterY < 0 || newCenterY < 0 ||
      Math.abs(newCenterY - oldCenterY - this.appItemParam.translateY) < 1) {
      log.showInfo(`dockItemMoveAnimation error end`)
      return;
    }
    animateTo({
      duration: 400,
      curve: curves.cubicBezierCurve(0.40, 0, 0.40, 1),
      onFinish: () => {
        log.showInfo('dockItemMoveInfoFunc onFinish');
      }
    }, () => {
      this.appItemParam.translateY = newCenterY - oldCenterY;
    })
  }

  private registerEventhub(): void {
    if (CheckEmptyUtils.isEmpty(this.viewDataMgr.gestureDockItemInfo.bundleName)) {
      log.showWarn('registerEventhub interrupt with invalid bundleName');
      return;
    }
    this.viewDataMgr.desktopContext?.eventHub.on(GestureDockConstants.UPDATE_ITEM_OPACITY, this.updateItemOpacity);
    if (this.viewDataMgr.dockType !== DockType.RESIDENT) {
      log.showWarn('registerEventhub interrupt with invalid dockType');
      return;
    }
    this.viewDataMgr.desktopContext?.eventHub
      .on(GestureDockEventIdUtil.getStartSqueezeEventId(this.viewDataMgr.gestureDockItemInfo), this.startSqueezeEvent);
    this.viewDataMgr.desktopContext?.eventHub
      .on(GestureDockEventIdUtil.getDockItemDropEventId(this.viewDataMgr.gestureDockItemInfo), this.dropEvent);
    this.viewDataMgr.desktopContext?.eventHub.on(GestureDockConstants.GESTURE_DOCK_ITEM_SQUEEZE_CANCEL,
      this.cancelSqueezeEvent);
    this.viewDataMgr.desktopContext?.eventHub.on(GestureDockConstants.GESTURE_DOCK_DELETE_ITEM, this.deleteAppEvent);
    this.viewDataMgr.desktopContext?.eventHub
      .on(GestureDockEventIdUtil.getDockItemVisibleEventId(this.viewDataMgr.gestureDockItemInfo), this.dockItemVisible);
    log.showInfo('registerEventhub finish, bundleName: %{public}s', this.viewDataMgr.gestureDockItemInfo.bundleName);
  }

  private unRegisterEventhub(): void {
    if (CheckEmptyUtils.isEmpty(this.viewDataMgr.gestureDockItemInfo.bundleName)) {
      log.showWarn('unregisterEventhub interrupt with invalid bundleName');
      return;
    }
    this.viewDataMgr.desktopContext?.eventHub
      .off(GestureDockEventIdUtil.getStartSqueezeEventId(this.viewDataMgr.gestureDockItemInfo), this.startSqueezeEvent);
    this.viewDataMgr.desktopContext?.eventHub
      .off(GestureDockEventIdUtil.getDockItemDropEventId(this.viewDataMgr.gestureDockItemInfo), this.dropEvent);
    this.viewDataMgr.desktopContext?.eventHub.off(GestureDockConstants.GESTURE_DOCK_ITEM_SQUEEZE_CANCEL,
      this.cancelSqueezeEvent);
    this.viewDataMgr.desktopContext?.eventHub.off(GestureDockConstants.GESTURE_DOCK_DELETE_ITEM, this.deleteAppEvent);
    this.viewDataMgr.desktopContext?.eventHub.off(
      GestureDockEventIdUtil.getDockItemVisibleEventId(this.viewDataMgr.gestureDockItemInfo), this.dockItemVisible);
    this.viewDataMgr.desktopContext?.eventHub.off(GestureDockConstants.UPDATE_ITEM_OPACITY, this.updateItemOpacity);
    log.showInfo('unRegisterEventhub finish, bundleName: %{public}s', this.viewDataMgr.gestureDockItemInfo.bundleName);
  }

  private longPressGestureEvent: AppIconLongPressGestureEventIface = {
    onLongPressPreGatherAction: (event: GestureEvent): void => {
    },
    onLongPressPreGatherActionEnd: (event: GestureEvent): void => {
      if (this.isInEditMode()) {
        this.badgeShow();
        return;
      }
    },
    onLongPressSnapshotAction: (event: GestureEvent): void => {
    },
    onLongPressGatherAction: (event: GestureEvent): void => {
    },
    onLongPressGatherActionEnd: (event: GestureEvent): void => {
    },
    onLongPressVibrateAction: (event: GestureEvent): void => {
      log.showInfo(`onLongPressVibrateAction:${this.viewDataMgr.gestureDockItemInfo.bundleName};${this.isInEditMode()}`);
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
      if (this.isInEditMode()) {
        this.badgeHide();
        return;
      }
    },
    onLongPressVibrateActionEnd: (event: GestureEvent): void => {
    },
    onLongPressZoomInAction: (event: GestureEvent): void => {
    },
    onIconLongPressZoomAnimation: (isZoomOut: boolean, bundleName: string): void => {
    },
    onLongPressVibrateActionCancel: (): void => {
      if (this.isInEditMode()) {
        return;
      }
      this.updateItemOpacity();
    },
    onLongPressSnapshotActionEnd: (event: GestureEvent): void => {
    },
    onLongPressSnapshotActionCancel: (): void => {
    }
  }

  private appIconGestureJudge: AppIconGestureJudgeIface = {
    onGestureJudgeBegin: (gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      if (this.isInEditMode() && this.viewDataMgr.dockType === DockType.RECENT) {
        // 编辑时,最近任务区按钮不允许操作
        log.showInfo(`appIconGestureJudge edit;${this.isInEditMode()};dockType:${this.viewDataMgr.dockType}`);
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    }
  }

  private appIconDragEvent: AppIconDragEventIface = {
    onDragStart: (event?: DragEvent): void => {
      log.showInfo(`appIconDragEvent:${this.viewDataMgr.gestureDockItemInfo.bundleName};${this.isInEditMode()}`);
      AppStorage.setOrCreate('isDrag', true);
      scbEventExclusiveManager.setEventExclusive(EventType.GESTUREDOCK_ITEM_DRAG, true);
      if (this.isInEditMode()) {
        GestureDockItemDragHandler.getInstance().handleDragStart(this.viewDataMgr.gestureDockItemInfo,
          GestureDockEventIdUtil.getSnapShotItemId(this.viewDataMgr.gestureDockItemInfo,
            this.viewDataMgr.dockDirection));
        this.appItemParam.visible = Visibility.Hidden;
      }
    },
    onDragEnd: (event?: DragEvent): void => {
      AppStorage.set('isDrag', false);
      scbEventExclusiveManager.setEventExclusive(EventType.GESTUREDOCK_ITEM_DRAG, false);
      if (this.isInEditMode()) {
        this.appItemParam.visible = Visibility.Visible;
        let isGestureDockDrag = AppStorage.get('isGestureDockDrag') as boolean;
        if (isGestureDockDrag) {
          log.showInfo(`emit dragEvent`);
          this.viewDataMgr.desktopContext?.eventHub.emit(GestureDockConstants.GESTURE_DOCK_DROP_ITEM);
        }
        this.badgeShow();
      }
    },
    onPreDrag: (preDragStatus: PreDragStatus): void => {
    },
    getDragPreviewBuilder: (): string | CustomBuilder | DragItemInfo => {
    }
  }

  private initAppIconConfig(): void {
    log.showInfo(`initAppIconConfig , bundleName: ${this.viewDataMgr.gestureDockItemInfo.bundleName}`);
    this.viewDataMgr.appIconConfig.setEnableName(false)
      .setEnableBadge(false)
      .setEnableHoverAnimation(true)
      .setEnableMultiSelect(false)
      .setIconContainerSize(GestureDockConstants.GESTURE_DOCK_ICON_SIZE);
    this.viewDataMgr.appIconConfig.setAppDataOfTransactionController(
      AppDataWrapper.getDefaultAppData(this.viewDataMgr.gestureDockItemInfo,
        GestureDockConstants.GESTURE_DOCK_ICON_RADIUS)
        .setExtraId(this.viewDataMgr.getItemId()))
    log.showInfo(`initAppIconConfig CustomIconId:${this.viewDataMgr.getItemId()}`);
    this.viewDataMgr.appIconConfig.setExternCb({
      onIconClick: (event?: ClickEvent, fingers?: number) => {
        if (this.viewDataMgr.itemOnClick) {
          this.viewDataMgr.itemOnClick(event, this.viewDataMgr.gestureDockItemInfo, 0);
        }
      }
    });
    this.viewDataMgr.iconEvent.setIconDragEventIface(this.appIconDragEvent);
    this.viewDataMgr.iconEvent.setIconGestureJudgeIface(this.appIconGestureJudge);
    this.viewDataMgr.iconEvent.setLongPressGestureEventIface(this.longPressGestureEvent);
  }

  private isInEditMode(): boolean {
    return this.viewDataMgr.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT;
  }

  private badgeShow(): void {
    // 400 为落位动效结束,150为角标显示动效时间
    animateTo({
      delay: DockAppItemConstants.BADGE_OPACITY_DELAY,
      duration: DockAppItemConstants.BADGE_OPACITY_ANIMATION,
      curve: Curve.EaseOut
    }, () => {
      this.appItemParam.badgeOpacity = 1;
    })
  }

  private badgeHide(): void {
    // 150为角标显示动效时间
    animateTo({
      duration: DockAppItemConstants.BADGE_OPACITY_ANIMATION,
      curve: Curve.EaseOut
    }, () => {
      this.appItemParam.badgeOpacity = 0;
    })
  }
}