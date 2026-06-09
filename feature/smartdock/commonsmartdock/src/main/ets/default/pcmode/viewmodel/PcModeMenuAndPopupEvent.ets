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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DockItemInfo, SnapshotInfo } from '@ohos/launchercommon';
import SmartDockConstants from '../../common/constants/SmartDockConstants';
import { PcModeDockPopupController, PcModeDockPopupMgr } from '../../manager/PcModeDockPopupMgr';
import { PcModeDockUtils } from '../../utils/PcModeDockUtils';
import SmartDockViewModel from '../../viewmodel/SmartDockViewModel';
import { PcModeMenuVm, PcModePopupVm } from './PcModeMenuAndPopupVm';
import { curves } from '@kit.ArkUI';
import { DockItemAnimationVm } from '../../viewmodel/DockItemAnimationVm';

const TAG = 'PcModeMenuAndpopupEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 处理ui侧menu显示隐藏逻辑, 以及与角标的显示互斥
export class PcModeMenuEvent {
  private menuVm: PcModeMenuVm;
  private popupVm: PcModePopupVm;
  private animationVm: DockItemAnimationVm;
  private isTouchUp: boolean = false; // 用于长按菜单角标显示隐藏

  constructor(menuVm: PcModeMenuVm, popupVm: PcModePopupVm, animationVm: DockItemAnimationVm) {
    this.menuVm = menuVm;
    this.popupVm = popupVm;
    this.animationVm = animationVm;
  }

  public onMenuAppear(): void {
    log.showInfo('dockMenu aboutToAppear');
    this.setMenuShowStatus(true);
    this.popupVm.isPopupShow = false;
  }

  public onMenuDisappear(): void {
    log.showInfo('dockMenu aboutToDisappear');
    this.setMenuShowStatus(false);
    this.popupVm.isPopupShow = false;
    if (this.isTouchUp) {
      this.isTouchUp = false;
      this.menuVm.badgeVisible = true;
    }
  }

  public setMenuShowStatus(isShow: boolean): void {
    this.menuVm.isMenuShow = isShow;
    AppStorage.setOrCreate('isDockMenuShow', isShow);
    if (isShow) {
      AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    }
  }

  public onTouchDown(): void {
    this.iconScaleAnimation(0.9);
  }

  public onTouchUp(): void {
    this.isTouchUp = true;
    if (!this.menuVm.isMenuShow) {
      this.isTouchUp = false;
      this.menuVm.badgeVisible = true;
    }
    this.iconScaleAnimation(1.0);
  }

  private iconScaleAnimation(scale: number): void {
    animateTo({
      duration: 160,
      curve: curves.interpolatingSpring(0, 1, 410, 38)
    }, () => {
      this.animationVm.centerX = '50%';
      this.animationVm.centerY = '50%';
      this.animationVm.scaleSize = scale;
    });
  }
}

// 处理ui侧popup显示隐藏逻辑, 以及与menu的显示互斥
export class PcModePopupEvent {
  private popupVm: PcModePopupVm;
  private menuVm: PcModeMenuVm;
  private popupMgr: PcModeDockPopupMgr = PcModeDockPopupMgr.getInstance();
  private hoverDelayTimer: number | null = null;
  private isHover: boolean = false;
  private popupController: PcModeDockPopupController = {
    popupAndMenuClose: () => {
      if (this.popupVm.isPopupShow) {
        this.popupVm.isPopupShow = false;
      }
      this.clearHoverDelayTimer();
      // 收到dock隐藏动效通知, 关闭菜单显示
      if (this.menuVm.isMenuShow) {
        this.menuVm.isMenuShow = false;
        AppStorage.setOrCreate('isDockMenuShow', false);
      }
    }
  };

  constructor(popupVm: PcModePopupVm, menuVm: PcModeMenuVm) {
    this.popupVm = popupVm;
    this.menuVm = menuVm;
  }

  public init(item: DockItemInfo): void {
    this.popupMgr.registerPopupController(item, this.popupController);
  }

  public destroy(item: DockItemInfo): void {
    this.popupMgr.unRegisterPopupController(item, this.popupController);
  }

  public onHoverAppItem(isHover: boolean | undefined, item: DockItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('onHoverAppItem item is empty');
      return;
    }
    const isHoverSnapshot: boolean = AppStorage.get('isHoverSnapshot') ?? false;
    const isDockMenuShow: boolean = AppStorage.get('isDockMenuShow') ?? false;
    log.showInfo(`onHoverAppItem, bundleName: ${item.bundleName}, isHover: ${isHover}, ` +
      `isPopupShow: ${this.popupVm.isPopupShow}, isDockMenuShow: ${isDockMenuShow}, ` +
      `isHoverSnapshot:${isHoverSnapshot}`);
    if (isDockMenuShow) {
      return;
    }
    this.clearHoverDelayTimer();
    this.isHover = isHover as boolean;
    if (isHover) {
      let snapshotList: SnapshotInfo[] = AppStorage.get<SnapshotInfo[]>('snapshotList') as SnapshotInfo[];
      if (!CheckEmptyUtils.isEmptyArr(snapshotList)) {
        log.showInfo(`onHoverAppItem, snapshotList not null, ` +
          `snapshotList.name: ${snapshotList?.[0]?.name}, length: ${snapshotList?.length}`);
        this.clearHoverDelayTimer();
        this.hoverDelayTimer = setTimeout(() => {
          const delayHoverSnapshotState: boolean = AppStorage.get('isHoverSnapshot') ?? false;
          log.showInfo(`onHoverAppItem, delayed, isHoverSnapshot:${delayHoverSnapshotState}`);
          if (!delayHoverSnapshotState) {
            // 150毫秒之内没hover到scrollerComponent就执行这块
            AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
            if (this.popupMgr.getCurrItem()?.bundleName === item?.bundleName &&
              this.popupMgr.getCurrItem()?.abilityName === item?.abilityName &&
              this.popupShowJudge(item) && this.popupVm.isPopupShow) {
              log.showInfo(`onHoverAppItem, the same app, directly return ${item.bundleName} `);
              return;
            }
            SmartDockViewModel.getInstance().onHoverEvent?.(item, true);
            this.popupMgr.closeOtherPopups(item);
            this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME, item);
            this.popupMgr.setCurrItem(item);
          }
        }, SmartDockConstants.HOVER_GAP_TIME);
      } else {
        AppStorage.setOrCreate<string>('hoverItemBundleName', item?.bundleName);
        SmartDockViewModel.getInstance().onHoverEvent?.(item, true);
        this.popupMgr.closeOtherPopups(item);
        this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME, item);
        this.popupMgr.setCurrItem(item);
        log.showInfo(`onHoverAppItem, snapshotList null, getSnapShot`);
      }
    } else {
      AppStorage.setOrCreate<string>('hoverItemBundleName', '');
      this.setShowPopupFalseWithDelay(600, item);
    }
  }

  public popupShowJudge(item: DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(`popupShowJudge, item is empty`);
      return false;
    }
    if (CheckEmptyUtils.isEmpty(this.popupMgr.getCurrItem())) {
      log.showError(`popupShowJudge, currItem is empty`);
      return false;
    }
    if (this.popupMgr.getCurrItem()?.bundleName != item.bundleName ||
      this.popupMgr.getCurrItem()?.abilityName != item.abilityName) {
      return false;
    }
    const isDockMenuShow: boolean = AppStorage.get('isDockMenuShow') ?? false;
    log.showInfo(`popupShowJudge, bundleName: ${item.bundleName}, result: ${!isDockMenuShow}`);
    return !isDockMenuShow;
  }

  public updatePopupData(item: DockItemInfo, show: boolean, bundleName: string, callback: Callback<void>): void {
    log.showInfo(`updateData ${show}, ${bundleName}`);
    if (show) {
      callback();
      this.popupMgr.closeOtherPopups(item);
      this.setShowPopupTrueWithDelay(SmartDockConstants.HOVER_DELAY_TIME, item);
    } else {
      callback();
      log.showInfo(`updateData isPopupShow false`);
      this.popupVm.isPopupShow = false;
    }
  }

  public popupHide(): void {
    if (!this.isHover) {
      log.showInfo('popupHide false');
      this.popupVm.isPopupShow = false;
      this.popupMgr.setCurrItem(null);
      PcModeDockUtils.clearSnapshotList();
    }
  }

  public onItemPopupStateChange(isVisible: boolean, item: DockItemInfo): void {
    log.showError(`onItemPopupStateChange isVisible:${isVisible},bundleName: ${item.keyName},` +
      ` , ${this.popupMgr.getCurrItem()?.keyName}`);
    let isItemOnHover: boolean = item?.keyName === this.popupMgr.getCurrItem()?.keyName;
    if (!isVisible && this.popupVm.isPopupShow && this.popupShowJudge(item)) {
      log.showInfo(`onItemPopupStateChange, onStateChange bundleName:${item?.bundleName}, abilityName:${item?.abilityName}`);
      this.popupVm.isPopupShow = false;
      this.popupMgr.setCurrItem(null);
      // 此处为了规避快速点击切换时的画面刷新
      PcModeDockUtils.clearSnapshotList();
      AppStorage.setOrCreate('isHoverSnapshot', false);
      AppStorage.setOrCreate('isClickOpenPopup', false);
    } else if (!isVisible && !isItemOnHover) {
      if (CheckEmptyUtils.isEmpty(this.popupMgr.getCurrItem())) {
        PcModeDockUtils.clearSnapshotList();
      }
      AppStorage.setOrCreate('isHoverSnapshot', false);
    }
    PcModeDockUtils.updateDockMissionsPopupShow(isVisible, isItemOnHover, this.popupMgr.getCurrItem());
  }

  private setShowPopupTrueWithDelay(delay: number, item: DockItemInfo): void {
    // hover需要重新延迟
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      this.popupMgr.setCurrItem(item);
      this.popupVm.isPopupShow = true;
      AppStorage.setOrCreate('isHoverSnapshot', false);
      this.clearHoverDelayTimer();
      log.showInfo(`setShowPopupTrueWithDelay happen end, isPopupShow: ${this.popupVm.isPopupShow}`);
    }, delay);
  }

  private clearHoverDelayTimer(): void {
    log.showDebug(`clearHoverDelayTimer happen`);
    if (this.hoverDelayTimer) {
      clearTimeout(this.hoverDelayTimer);
      this.hoverDelayTimer = null;
    }
  }

  private setShowPopupFalseWithDelay(delay: number, item: DockItemInfo): void {
    // hover需要重新延迟
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      const isHoverSnapshot: boolean = AppStorage.get('isHoverSnapshot') ?? false;
      const isDockMenuShow: boolean = AppStorage.get('isDockMenuShow') ?? false;
      log.showInfo(`setShowPopupFalseWithDelay, ${isHoverSnapshot}, ${isDockMenuShow}, ${this.isHover}`);
      if (!isHoverSnapshot && !isDockMenuShow && !this.isHover) {
        const currItem: DockItemInfo | null = this.popupMgr.getCurrItem();
        if (CheckEmptyUtils.isEmpty(currItem) ||
          (currItem?.bundleName === item?.bundleName && currItem?.abilityName === item?.abilityName)) {
          this.popupMgr.setCurrItem(null);
        }
        this.popupVm.isPopupShow = false;
        this.clearHoverDelayTimer();
      }
    }, delay);
  }
}