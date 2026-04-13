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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { NtfStatusIconEvent } from '../common/event/NotificationEvent';
import { NotificationCompatibleConverter } from '../parser/NotificationCompatibleConverter';
import type { NotificationEntry } from '../model/NotificationEntry';
import { StatusBarNotificationEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { InnerEventUtil, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { image } from '@kit.ImageKit';

const TAG = 'NotificationStatusBarEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 发送状态栏通知图标事件
 */
export class NotificationStatusBarEventManager {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationStatusBarEventManager());

  /**
   * 需要在状态栏显示的通知信息列表。
   */
  private iconNtfList: NotificationBase[] = [];

  /**
   * 上一次post事件的通知列表，当两次列表相同时，不post事件
   */
  private lastIconList: NtfStatusBarIconInfo[] = [];

  constructor() {
    this.initIconProduceOn();
  }

  /**
   * 通过starter拉起应用的时候，发送状态栏图标事件
   * @param ntf 拉起应用
   */
  public postStateBarIconEventByStarter(ntf: NotificationBase): void {
    log.showInfo(`postStateBarIconEventByStarter. ntf: ${ntf.hashCode}`)
    this.iconNtfList = this.iconNtfList.filter(iconNtf => iconNtf.hashCode !== ntf.hashCode);
    this.refreshLastIconList(this.iconNtfList);
    InnerEventUtil.post(StatusBarNotificationEvent, new StatusBarNotificationEvent(this.iconNtfList));
    // 兼容老的事件，等状态栏切换监听事件后可以删除
    this.postNtfStatusIconEvent(this.iconNtfList);
  }

  /**
   * 发送状态栏图标变化事件。
   */
  public postStatusBarNotificationEvent(inputNtfList: NotificationBase[]): void {
    const ntfList = inputNtfList.filter(ntf => !ntf.isLiveView());

    this.iconNtfList = ntfList;

    if (!this.isIconListUpdate(this.iconNtfList)) {
      log.showInfo('icon list not update');
      return;
    }
    // 发送状态栏图标事件
    log.info(`post statusbar notification icon, length: ${ntfList.length}`);
    InnerEventUtil.post(StatusBarNotificationEvent, new StatusBarNotificationEvent(ntfList));
    this.refreshLastIconList(ntfList);

    // TODO: 兼容老的状态栏图标事件，状态栏切换到新事件后删掉
    this.postNtfStatusIconEvent(ntfList);
  };

  private refreshLastIconList(ntfList: NotificationBase[]): void {
    this.lastIconList = [];
    ntfList.forEach(ntf => {
      this.lastIconList.push({ iconUniKey: this.getSbIconUniKey(ntf), appIcon: ntf.appIcon, smallIcon: ntf.smallIcon });
    });
  }

  /**
   * 发送NtfStatusIconEvent事件。状态栏整改到为NotificationBase后可删除
   * @param ntfList
   */
  private postNtfStatusIconEvent(ntfList: NotificationBase[]): void {
    const entryList: NotificationEntry[] = [];

    ntfList.forEach(ntf => {
      // 将新的通知数据结构转换为老的
      const entry = NotificationCompatibleConverter.convert(ntf, Reflect.get(ntf, 'innerRequest'));
      entryList.push(entry);
    })

    InnerEventUtil.post(NtfStatusIconEvent, NtfStatusIconEvent.create(entryList));
  }

  /**
   * icon列表是否更新
   * @param iconNtfHashList
   * @param lastIconList
   * @returns
   */
  private isIconListUpdate(iconNtfList: NotificationBase[]): boolean {
    if (iconNtfList.length !== this.lastIconList.length) {
      log.showInfo(`icon list length change from ${this.lastIconList.length} to ${iconNtfList.length}`);
      return true;
    }

    if (iconNtfList.findIndex((icon, index) => this.lastIconList[index].iconUniKey !==
    this.getSbIconUniKey(icon) || this.lastIconList[index].smallIcon !== icon.smallIcon ||
      this.lastIconList[index].appIcon !== icon.appIcon) > -1) {
      return true;
    }
    return false;
  }

  /**
   * 获取状态栏图标唯一值
   * @param entry 通知实例
   * @returns 状态栏图标唯一值
   */
  private getSbIconUniKey(entry: NotificationBase): string {
    if (!entry) {
      log.showInfo(`getSbIconUniKey empty entry`);
      return '';
    }

    if (entry.creatorBundleName && entry.creatorBundleName !== '') {
      return `${entry.creatorBundleName}_${entry.creatorUid}`;
    }

    log.showInfo(`getSbIconUniKey empty creatorBundleName`);
    return `${entry.creatorUid}`;
  }

  /**
   * 状态栏图标变化事件生产。状态栏加载慢时，收不到首次抛出的通知图标事件
   */
  private initIconProduceOn(): void {
    InnerEventUtil.produceOn(StatusBarNotificationEvent, (): StatusBarNotificationEvent => {
      return new StatusBarNotificationEvent(this.iconNtfList);
    });

    // TODO: 兼容老的状态栏图标事件，状态栏切换到新事件后删掉
    InnerEventUtil.produceOn(NtfStatusIconEvent, (): NtfStatusIconEvent => {
      const entryList: NotificationEntry[] = [];
      this.iconNtfList.forEach(ntf => {
        // 将新的通知数据结构转换为老的
        const entry = NotificationCompatibleConverter.convert(ntf, Reflect.get(ntf, 'innerRequest'));
        entryList.push(entry);
      })
      return NtfStatusIconEvent.create(entryList);
    });
  }
}

interface NtfStatusBarIconInfo {
  /**
   * 通知小图标
   */
  smallIcon?: image.PixelMap;

  /**
   * 应用图标
   */
  appIcon?: image.PixelMap | string;

  /**
   * 获取状态栏图标唯一值
   */
  iconUniKey: string;
}