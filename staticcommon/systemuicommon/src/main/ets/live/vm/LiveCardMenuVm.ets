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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveItemBaseVm } from './LiveBaseVm';
import { ILiveCardMenuVm } from '../interface/ILiveCardMenuVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveVmInjector } from '../LiveVmInjector';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { ResourceVm } from '../../vm/ResourceVm';
import { DeleteNotificationMaintenance } from '../../maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { ILiveSwitchVm } from '../interface/ILiveSwitchVm';

const TAG = 'LiveCardMenuVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardMenuVm extends LiveItemBaseVm implements ILiveCardMenuVm {
  private static instances: Set<LiveCardMenuVm> = new Set();
  /**
   * 从右向左滑动，展开或关闭的临界值
   */
  private static readonly SWIPE_LEFT_CRITICAL = 12;
  private static readonly MENU_OFFSET_RATIO: number = 2.0;

  protected itemVm = this.vmInjector.getCardListItemVm(this.live);

  @Trace public isTouching: boolean = false;

  @Trace public menuOpacityWithAnim: number = 1;

  @Trace public resetMenuWithAnim: boolean = false;

  @Computed get isShowMenu(): boolean {
    return this.live.isRemoveAllowed;
  }
  @Computed get menuOpacity(): number {
    if (this.isRemoving) {
      return this.itemVm.containerOpacity;
    }
    if (this.vmInjector.getSwitchVm().isExpanding || this.vmInjector.getSwitchVm().isCollapsing) {
        return 0;
    }
    log.showInfo(`contentOffsetLeft: ${this.itemVm.containerOffsetX}, menuWidth: ${this.menuWidth}`);
    if (this.itemVm.containerOffsetX <= -this.menuWidth) {
      return 1;
    }
    return -this.itemVm.containerOffsetX / this.menuWidth;
  }
  @Computed get menuOffsetX(): number {
    if (this.isRemoving) {
      return this.itemVm.containerOffsetX + this.menuWidth;
    }
    // 当卡片左滑超过距离超过菜单宽度时，菜单需要跟着左滑
    if (-this.itemVm.containerOffsetX > this.menuWidth) {
      return (this.itemVm.containerOffsetX + this.menuWidth) / LiveCardMenuVm.MENU_OFFSET_RATIO;
    }
    return 0;
  }
  @Computed get switchVm(): ILiveSwitchVm {
    return this.vmInjector.getSwitchVm();
  }

  @Trace protected menuWidth: number = 0;
  @Trace public isSwiped: boolean = false;

  /**
   * 开始滑动时的横向偏移量
   */
  protected startOffsetX: number = 0;
  /**
   * 上一次滑动位置
   */
  protected lastOffsetX: number = 0;
  /**
   * 是否从左向右横滑
   */
  protected isLeftToRight: boolean = false;
  /**
   * 是否正在删除
   */
  protected isRemoving: boolean = false;

  constructor(vmInjector: LiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    LiveCardMenuVm.instances.add(this);
  }

  public onMenuSizeChange = (_: SizeOptions, size: SizeOptions): void => {
    this.menuWidth = size.width as number;
    log.showInfo(`onMenuSizeChange for ${this.live.hashCode}, width: ${size.width}`);
  };

  public removeLive = (): void => {
    log.showWarn(`Remove live ${this.live.hashCode}`);
    this.isRemoving = true;
    this.vmInjector.getCapsuleVm(this.live).isToDelete = true;
    this.itemVm.doRemoveAnimation().then(() => {
      NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.LIVE_PANEL_REMOVE);
    });
    NotificationDataManager.instance.freeze(NotificationDataManager.REASON.LIVE_PANEL_REMOVE);
    DeleteNotificationMaintenance.addNtfMap([this.live], DeleteNotificationType.LIVE_LEFT_SLIDE_CLICK_DELETE, false);
    NotificationDataManager.instance.removeLiveView([this.live]);
    LiveHiSysEvent.reportLiveLeftDelEvent(this.live);
  };

  protected onPanStart = (event: GestureEvent): void => {
    if (this.switchVm.isCollapsing) {
      return;
    }
    log.showInfo(`onPanStart for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);
    this.reset('exceptSelf');
    this.startOffsetX = this.itemVm.containerOffsetX;
    this.isSwiped = true;
    this.isTouching = true;
  };

  protected onPanUpdate = (event: GestureEvent): void => {
    if (this.switchVm.isCollapsing) {
      return;
    }
    log.showInfo(`onPanUpdate for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);
    const offsetX = event.offsetX * (ResourceVm.instance.isRTL ? -1 : 1);
    this.itemVm.updateSwipeOffset(this.startOffsetX + offsetX, false);
  };

  protected onPanEnd = (event: GestureEvent): void => {
    if (this.switchVm.isCollapsing) {
      return;
    }
    log.showWarn(`onPanEnd for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);
    this.isLeftToRight = event.offsetX > 0;
    const offsetX = event.offsetX * (ResourceVm.instance.isRTL ? -1 : 1);
    this.stop(offsetX);
  };

  private onPanCancel = (): void => {
    this.stop(0);
  };

  public horizontalPanGesture = new PanGestureHandler({ direction: PanDirection.Horizontal })
    .onActionStart(this.onPanStart)
    .onActionUpdate(this.onPanUpdate)
    .onActionEnd(this.onPanEnd)
    .onActionCancel(this.onPanCancel);

  public reset(type: 'self' | 'exceptSelf' | 'all'): void {
    if (type === 'self') {
      log.showWarn(`Reset self ${this.live.hashCode}`);
      if (this.isRemoving) {
        log.showInfo('Reset self not need, live is removing');
        return;
      }
      this.itemVm.updateSwipeOffset(0, true);
      return;
    }
    log.showInfo(`Reset LiveCardMenuVm type is ${type}, instances length: ${LiveCardMenuVm.instances.size}`);
    for (const instance of LiveCardMenuVm.instances.values()) {
      if (type === 'exceptSelf' && instance === this) {
        log.showWarn(`Reset not need at item: instance ${instance.itemVm.live.hashCode} is self`);
        continue;
      }
      if (!instance.itemVm.containerOffsetX || instance.vmInjector.scene !== this.vmInjector.scene) {
        log.showWarn(`Reset not need at item: ${instance.itemVm.live.hashCode},
        offset is ${instance.itemVm.containerOffsetX},
        scene is same: ${instance.vmInjector.scene === this.vmInjector.scene}`);
        continue;
      }
      if (instance.isTouching) {
        log.showWarn(`Reset not need at item: instance ${instance.itemVm.live.hashCode} is touching`);
        continue;
      }
      if (instance.isRemoving) {
        log.showInfo('Reset not need at item: instance is in remove');
        continue;
      }
      log.showInfo(`Reset ${instance.live.hashCode}`);
      instance.itemVm.updateSwipeOffset(0, true);
    }
  }

  private stop(offsetX: number): void {
    log.showInfo(`Stop swipe ${this.live.hashCode} offsetX: ${offsetX}, menuWidth: ${this.menuWidth}`);
    this.isTouching = false;
    const isLeftToRight = offsetX > 0;
    let endOffsetX = 0;

    if (isLeftToRight) {
      // 右滑超过临界值，则恢复到原位，否则保持之前的位置
      if (offsetX >= LiveCardMenuVm.SWIPE_LEFT_CRITICAL) {
        endOffsetX = 0;
      } else {
        endOffsetX = this.startOffsetX;
      }
    } else {
      // 左滑超过临界值，则滑到菜单宽度的位置，否则保持之前的位置
      if (offsetX <= -LiveCardMenuVm.SWIPE_LEFT_CRITICAL) {
        endOffsetX = -this.menuWidth;
      } else {
        endOffsetX = this.startOffsetX;
      }
    }
    this.itemVm.updateSwipeOffset(endOffsetX, true);
  }

  public init(): void {
    LiveCardMenuVm.instances.add(this);
  }

  public destroy(): void {
    LiveCardMenuVm.instances.delete(this);
  }
}