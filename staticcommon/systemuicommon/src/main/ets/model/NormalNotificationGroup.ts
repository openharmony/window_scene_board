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
import { NormalNotification } from './NormalNotification';
import { NotificationBase } from './NotificationBase';
import { NotificationRole } from './NotificationContent';

/**
 * 普通组通知
 */
export class NormalNotificationGroup extends NotificationBase {
  /**
   * 普通组通知角色
   */
  readonly role: NotificationRole = NotificationRole.NORMAL_GROUP;
  /**
   * 子通知
   */
  public readonly children: NormalNotification[] = [];

  /**
   * 组通知构造器
   * @param ntf 通知对象
   * @param otherOtherList 子通知集合
   */
  constructor(ntf: NormalNotification, ...otherOtherList: NormalNotification[]) {
    super();
    this.children.push(ntf, ...otherOtherList);
    this.children.sort((a, b) => b.deliveryTime - a.deliveryTime);
    ntf = this.children[0];

    this.hashCode = ntf.groupKey;
    this.groupKey = ntf.groupKey;
    this.creatorBundleName = ntf.creatorBundleName;
    this.creatorUserId = ntf.creatorUserId;
    this.creatorUid = ntf.creatorUid;
    this.bundleType = ntf.bundleType;
    this.appLabel = ntf.appLabel;
    this.appVersionName = ntf.appVersionName;
    this.appIcon = ntf.appIcon;
    this.appIndex = ntf.appIndex;
    this.isOngoing = ntf.isOngoing;
    this.isDisplayAtTop = ntf.isDisplayAtTop;
    this.isShowStatusBarIcon = ntf.isShowStatusBarIcon;
    this.isDeliverNotification = ntf.isDeliverNotification;
    this.overlayIconStyle = ntf.overlayIconStyle;
    if (this.isDeliverNotification) {
      this.deliverNotificationKey = ntf.deliverNotificationKey;
    }
    this.isCollaNotification = ntf.isCollaNotification;
    this.isSettingIgnore = ntf.isSettingIgnore;
    this.category = ntf.category;
    this.deliveryTime = ntf.deliveryTime;
    this.slotType = ntf.slotType;
    this.isRemoveAllowed = this.children.every((c) => c.isRemoveAllowed);
    this.isClearAllowed = this.children.every((c) => c.isClearAllowed);
    this.isFromPush = ntf.isFromPush;
    this.smallIcon = ntf.smallIcon;
    this.isFromSystemApp = ntf.isFromSystemApp;
  }

  /**
   * 是否为空组
   * @returns
   */
  isEmpty(): boolean {
    return this.children.length === 0;
  }

  /**
   * 查找子通知
   * @param hashCode
   * @returns
   */
  getChild(hashCode: string): NormalNotification | undefined {
    return this.children.find((c) => c.hashCode === hashCode);
  }

  /**
   * 添加或更新子通知
   * @param ntf
   * @returns 返回新的组通知对象
   */
  addOrUpdateChild(ntf: NormalNotification): NormalNotificationGroup {
    const index = this.children.findIndex((item) => item.hashCode === ntf.hashCode);
    if (index > -1) {
      this.children[index] = ntf;
    } else {
      this.children.push(ntf);
    }
    const newGroup = new NormalNotificationGroup(this.children[0], ...this.children.slice(1));
    newGroup.updateKey(this.key, true);
    return newGroup;
  }

  /**
   * 删除子通知
   * @param hashCode
   * @returns 返回新的组通知对象
   */
  removeChild(hashCode: string): NormalNotificationGroup | undefined {
    const children = this.children.filter((c) => c.hashCode !== hashCode);
    if (!children.length) {
      return undefined;
    }
    const newGroup = new NormalNotificationGroup(children[0], ...children.slice(1));
    newGroup.updateKey(this.key, true);
    return newGroup;
  }
}