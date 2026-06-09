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

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { EventType, scbEventExclusiveManager } from '@ohos/windowscene';
import {
  AppDataWrapper,
  CommonConstants,
  ReceiveEventInfo,
  vibratorMgr
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppIconLongPressGestureEventIface } from '@ohos/launchercommon/Index';
import GestureDockAllAppsItemViewDataMgr from '../viewdata/GestureDockAllAppsItemViewDataMgr';
import { DockAllAppsItemParam } from '../viewdata/GestureDockAllAppsItemParam';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { GestureDockEventIdUtil } from '../../../common/util/GestureDockEventIdUtil';
import { SystemNavReporter } from '../../../common/util/SystemNavReporter';
import { GestureDockBarViewModel } from '../../../dockbar/viewmodel/GestureDockBarViewModel';

const TAG = 'GestureDockAllAppsItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAppItemViewEventMgr
 */
export default class GestureDockAllAppsItemViewEventMgr {
  public viewDataMgr: GestureDockAllAppsItemViewDataMgr;
  public appItemParam: DockAllAppsItemParam;

  /**
   * 构造器
   *
   * @param viewDataMgr 参数对象
   */
  public constructor(viewDataMgr: GestureDockAllAppsItemViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.appItemParam = this.viewDataMgr.appItemParam;
  }

  /**
   * onAboutToAppear
   */
  public aboutToAppear(): void {
    this.initIcon();
    this.registerEvent();
    this.onGestureDockChange();
  }

  /**
   * AboutToDisAppear
   */
  public aboutToDisappear(): void {
    this.unRegisterEvent();
  }

  /**
   * 图标点击事件
   * @param event 事件
   */
  public onAllAppsItemClick(event?: ClickEvent): void {
    log.showInfo(`gesture dock onAllAppsItemClick`);
    let dockViewData = this.viewDataMgr.dockViewModel.getViewData();
    if (dockViewData?.getGestureDockShowMode() !== GestureDockMode.EDIT) {
      if (this.viewDataMgr.itemOnClick) {
        this.viewDataMgr.itemOnClick(event);
      }
      log.showError('showMode not edit');
      return;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.GESTUREDOCK_EDITMODE_ALLITEM_CLICK)) {
      log.showInfo(`gesture dock item is dragged, all apps item can not click`);
      return;
    }
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let residentList = residentApps.filter((item) => {
      return !CheckEmptyUtils.isEmpty(item.bundleName);
    })
    log.showInfo(`plus onClick,showBadge is ${this.appItemParam.isShowBadge},residentLength is ${residentList.length}`);
    if (this.appItemParam.isShowBadge && residentList.length < GestureDockConstants.MAX_CUSTOM_COUNT) {
      SystemNavReporter.reportAddAppToDock(this.viewDataMgr.item?.bundleName, this.viewDataMgr.dockAddAppSource);
      this.viewDataMgr.desktopContext?.eventHub.emit(GestureDockConstants.GESTURE_DOCK_ADD_ITEM, this.viewDataMgr.item);
    } else if (residentList.length >= GestureDockConstants.MAX_CUSTOM_COUNT && this.appItemParam.isShowBadge) {
      this.viewDataMgr.desktopContext?.eventHub.emit(GestureDockConstants.GESTURE_DOCK_ADD_ITEM, this.viewDataMgr.item);
    } else {
      log.showWarn(`notShowBadge, return`);
    }
  }

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string) => {
      if (event === GestureDockEventIdUtil.getAllAppsGrayEventId(this.viewDataMgr.item)) {
        this.onGestureDockChange();
      }
    }
  };
  private updateItemOpacity = () => this.appItemParam.iconOpacity = this.viewDataMgr.getOpacity();

  /**
   * dock区域发生变化,监控本按钮的状态变动
   */
  private onGestureDockChange(): void {
    let dockViewData = this.viewDataMgr.dockViewModel.getViewData();
    this.viewDataMgr.gestureDockDirection = dockViewData?.getGestureDockDirection() || 0;
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[] || [];
    // 从dockBar中获取最近任务数据
    let dockBar = GestureDockBarViewModel.getInstance().getViewEvent();
    let recentApps = dockBar?.getRecentApps() || [];
    // 最近任务区与可编辑区合并后判断是否可添加
    let filterList: GestureDockItemInfo[] = [...recentApps, ...residentApps]
    this.appItemParam.isShowBadge =
      !filterList.some(item1 => GestureDockUtil.areTwoAppItemsSame(item1, this.viewDataMgr.item));
    this.appItemParam.iconOpacity = this.viewDataMgr.getOpacity();
  }

  private longPressGestureEvent: AppIconLongPressGestureEventIface = {
    onLongPressPreGatherAction: (event: GestureEvent): void => {
    },
    onLongPressPreGatherActionEnd: (event: GestureEvent): void => {
    },
    onLongPressSnapshotAction: (event: GestureEvent): void => {
    },
    onLongPressGatherAction: (event: GestureEvent): void => {
    },
    onLongPressGatherActionEnd: (event: GestureEvent): void => {
    },
    onLongPressVibrateAction: (event: GestureEvent): void => {
      let dockViewData = this.viewDataMgr.dockViewModel.getViewData();
      if (dockViewData?.getGestureDockShowMode() === GestureDockMode.EDIT) {
        if (this.appItemParam.isShowBadge) {
          this.onAllAppsItemClick();
        }
        log.showInfo(`click notShowBadge, return`);
        return;
      }
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    },
    onLongPressVibrateActionEnd: (event: GestureEvent): void => {
    },
    onLongPressZoomInAction: (event: GestureEvent): void => {
    },
    onIconLongPressZoomAnimation: (isZoomOut: boolean, bundleName: string): void => {
    },
    onLongPressVibrateActionCancel: (): void => {
    },
    onLongPressSnapshotActionEnd: (event: GestureEvent): void => {
    },
    onLongPressSnapshotActionCancel: (): void => {
    }
  }

  private initIcon(): void {
    this.viewDataMgr.appIconConfig.setEnableBadge(false);
    this.viewDataMgr.appIconConfig.setEnableDrag(false);
    this.viewDataMgr.appIconConfig.setEnableHoverAnimation(true);
    this.viewDataMgr.appIconConfig.setEnableShadow(false);
    this.viewDataMgr.appIconConfig.setIsDesktopItem(false);
    this.viewDataMgr.appIconConfig.setIsReuseIconConfigAndEvent(true);
    this.viewDataMgr.appIconConfig.setEnableNameShadow(false);
    this.viewDataMgr.appIconConfig.setEnableMultiSelect(false);
    this.viewDataMgr.appIconConfig.setEnableWallpaperFontColor(false);
    this.viewDataMgr.appIconConfig.setEnableInstallAnimate(false);
    this.viewDataMgr.appIconConfig.setAppDataOfTransactionController(
      AppDataWrapper.getDefaultAppData(this.viewDataMgr.item, this.viewDataMgr.allAppsStyleConfig?.iconRadius)
        .setExtraId(this.viewDataMgr.getItemId()))
    log.showInfo(`initIcon CustomIconId:${this.viewDataMgr.item.iconId}`);
    this.viewDataMgr.appIconConfig.setExternCb({
      onIconClick: (event?: ClickEvent, fingers?: number) => {
        this.onAllAppsItemClick(event);
      }
    });
    this.viewDataMgr.iconEvent.setLongPressGestureEventIface(this.longPressGestureEvent);
    this.viewDataMgr.appNameVm.modifier.enableWallpaperFontColor = false;
  }

  private registerEvent(): void {
    // 注册app gray事件
    if (this.viewDataMgr.item) {
      let grayEvent: string = GestureDockEventIdUtil.getAllAppsGrayEventId(this.viewDataMgr.item);
      localEventManager.registerEventListener(this.localEventListener, [grayEvent]);
    }
    this.viewDataMgr.desktopContext?.eventHub.on(GestureDockConstants.UPDATE_ITEM_OPACITY, this.updateItemOpacity);
  }

  private unRegisterEvent(): void {
    localEventManager.unregisterEventListener(this.localEventListener);
    this.viewDataMgr.desktopContext?.eventHub.off(GestureDockConstants.UPDATE_ITEM_OPACITY, this.updateItemOpacity);
  }
}