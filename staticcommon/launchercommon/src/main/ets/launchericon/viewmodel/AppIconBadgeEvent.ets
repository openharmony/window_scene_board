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

import { LogDomain, Logger } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import BadgeItemInfo from '../../bean/BadgeItemInfo';
import { ReceiveEventInfo } from '../../bean/ReceiveEventInfo';
import { BadgeListener, BadgeManager } from '../../manager/BadgeManager';
import { CustomBadgeManager } from '../../model/CustomBadgeManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { AppIconBadgeVm } from './AppIconBadgeVm';

const TAG = 'AppIconBadgeEvent';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);

export class AppIconBadgeEvent {
  private iconBadgeVm: AppIconBadgeVm;
  private itemInfo: AppItemInfo = new AppItemInfo();
  private badgeManager: BadgeManager = BadgeManager.getInstance();

  private readonly badgeListener: BadgeListener = {
    onUpdate: (badgeInfo: BadgeItemInfo) => {
      log.showInfo(TAG, `update badgeNumber=${badgeInfo?.badgeNumber}, bundleName=${badgeInfo?.bundleName}` +
        `, appIndex=${badgeInfo?.appIndex}, isShow=${badgeInfo?.isShow}`);
      this.iconBadgeVm.badgeNumber = badgeInfo?.badgeNumber ?? 0;
      this.iconBadgeVm.enable = badgeInfo?.isShow ?? true;
      this.iconBadgeVm.visible = this.iconBadgeVm.badgeNumber > 0 && this.iconBadgeVm.enable;
    }
  };

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: boolean | number) => {
      if (!this.iconBadgeVm.isUpdateSuperposeBadge) {
        log.showInfo(TAG, 'is not UpdateSuperposeBadge');
        return;
      }
      log.showInfo(TAG, 'isUpdateSuperposeBadge, badgeNumber is' + params);
      this.iconBadgeVm.badgeNumber = params as number;
    }
  };

  constructor(vm: AppIconBadgeVm) {
    this.iconBadgeVm = vm;
  }

  private updateBadge(): void {
    this.badgeManager.getBadgeDisplayNumberByBundle(this.itemInfo, (badgeNumber: number): void => {
      this.iconBadgeVm.badgeNumber = badgeNumber;
      this.itemInfo.badgeNumber = badgeNumber;
      if (badgeNumber > 0 && this.iconBadgeVm.visible) {
        CustomBadgeManager.getInstance().setAppBadgeValue(this.itemInfo, this.itemInfo.badgeNumber);
      }
    });
  }

  public init(itemInfo: AppItemInfo): void {
    this.itemInfo = itemInfo;

    if (GridLayoutUtil.isAppInstalled(this.itemInfo)) {
      this.updateBadge();
      this.badgeManager.registerBadgeListener(this.itemInfo, this.badgeListener);
    }
    localEventManager.registerEventListener(this.localEventListener, [`badgeUpdate${this.itemInfo.bundleName}${this.itemInfo.appIndex ?? 0}`]);
    this.iconBadgeVm.modifier.onInit = (): void => {
      log.showInfo(TAG, 'modifier init');
      this.iconBadgeVm.modifier.attribute?.scale({ x: 1, y: 1 });
      this.iconBadgeVm.modifier.attribute?.translate({ x: 0, y: 0 });
    }
  }

  public destroy(): void {
    if (GridLayoutUtil.isAppInstalled(this.itemInfo)) {
      this.badgeManager.unRegisterBadgeListener(this.itemInfo, this.badgeListener);
    }
    localEventManager.unregisterEventListener(this.localEventListener);
  }

  public onActive(isActive: boolean): void {
    if (this.iconBadgeVm.badgeNumber <= 0) {
      return;
    }
    log.showInfo(TAG,
      `isActive: ${isActive}, bundleName: ${this.itemInfo.bundleName}, appIndex: ${this.itemInfo.appIndex}`);
    this.iconBadgeVm.visible = !isActive;
    if (!isActive) {
      this.iconBadgeVm.modifier.attribute?.scale({ x: 1, y: 1 });
      this.iconBadgeVm.modifier.attribute?.translate({ x: 0, y: 0 });
    }
  }

  public onIconScale(scale: number, iconSize: number): void {
    if (!this.iconBadgeVm.visible || this.iconBadgeVm.badgeNumber <= 0) {
      return;
    }
    log.showInfo(TAG,
      `onIconScale: ${scale}, bundleName: ${this.itemInfo.bundleName}, appIndex: ${this.itemInfo.appIndex}`);
    if (scale === 1) {
      this.iconBadgeVm.modifier.attribute?.scale({ x: 1, y: 1 });
      this.iconBadgeVm.modifier.attribute?.translate({ x: 0, y: 0 });
    } else {
      let textWidth = this.iconBadgeVm.modifier.width;
      let textHeight = this.iconBadgeVm.modifier.height;
      let textOffsetX = this.iconBadgeVm.modifier.xOffset;
      let textOffsetY = this.iconBadgeVm.modifier.yOffset;

      // 图标和角标相对独立，为达到按压共同缩放的效果需要计算translate偏移量
      let offsetX = (iconSize - textWidth) / 2 + textOffsetX;
      let offsetY = (iconSize - textHeight) / 2 - textOffsetY;
      let translateX = offsetX * (1 - scale);
      let translateY = offsetY * (1 - scale);
      log.showInfo(TAG,
        'iconSize: %{public}d, textWidth: %{public}d, textHeight: %{public}d, textOffsetX: %{public}d, ' +
        'textOffsetY: %{public}d', iconSize, textWidth, textHeight, textOffsetX, textOffsetY);
      log.showInfo(TAG, `translateX: -${translateX}, translateY: ${translateY}`);

      this.iconBadgeVm.modifier.attribute?.scale({ x: scale, y: scale });
      this.iconBadgeVm.modifier.attribute?.translate({ x: -translateX, y: translateY });
    }
  }
}