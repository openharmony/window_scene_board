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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DateTimeVM } from '@ohos/customcomponent/src/main/ets/vm/DateTimeVM';
import { INotificationTimeVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NotificationBase, InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { TimeChangeEvent } from '@ohos/frameworkwrapper';
import { DateUtils } from '@ohos/customcomponent/src/main/ets/common/DateUtils';
import { NotificationConstants } from '../common/NotificationConstants';

const TAG = 'NotificationTimeVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ObservedV2
export class NotificationTimeVm extends NotificationItemBaseVm implements INotificationTimeVm {
  @Trace public timeText: string = '';
  public isAlwaysShowButton: boolean = false;

  private timeVm = new DateTimeVM();

  init(): void {
    this.timeVm.initOv(this.ntf.deliveryTime, this.ntf.hashCode, this);
    if (this.isAlwaysShowButtonPackage()) {
      this.isAlwaysShowButton = true;
      InnerEventUtil.on(TimeChangeEvent, this.onTimeChangeEvent);
    }
  }

  destroy(): void {
    this.timeVm.onDestroy();
    InnerEventUtil.off(TimeChangeEvent, this.onTimeChangeEvent);
  }

  onUpdate(ntf: NotificationBase): void {
    this.ntf = ntf;
    this.timeVm.updateOvTimeMillis(ntf.deliveryTime);
  }

  onTimeTextUpdate(timeText: string) {
    this.timeText = timeText;
    log.showInfo(`Update time text for ${this.ntf.hashCode}: ${this.timeText}`);
  }

  /**
   * 应用是否默认展示通知图标
   * @returns
   */
  private isAlwaysShowButtonPackage(): boolean {
    return NotificationConstants.DEFAULT_EXPAND_BUTTON_PACKAGE_NAME.has(this.ntf.creatorBundleName);
  }

  /**
   * 时间变化回调，判断是否在默认显示通知按钮时间内
   */
  private onTimeChangeEvent = (event: TimeChangeEvent): void => {
    const now = Date.now();
    // 微秒转换分钟，向上取整
    let timeMinute = Math.ceil(this.ntf.deliveryTime / DateUtils.MINUTE_IN_MILLIS) * DateUtils.MINUTE_IN_MILLIS;
    let duration = now - timeMinute;
    if (duration > DateUtils.HOUR_IN_MILLIS * NotificationConstants.EXPAND_BUTTON_DURATION) {
      log.showInfo(`${this.ntf.hashCode} default show notification button time over`);
      this.isAlwaysShowButton = false;
      return;
    }
    this.isAlwaysShowButton = true;
  }
}