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
import { AttributeUpdater } from '@ohos.arkui.modifier';
import bundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LogWithHa } from '@ohos/systemuicommon';
import { NotificationExceptionCode } from '../../maintenance/NotificationExceptionCode';
import { NotificationEntry } from '../../model/NotificationEntry';

const TAG = 'NtfAppIconModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NtfAppIconModifier extends AttributeUpdater<ImageAttribute> {
  private radius: Resource = $r('app.float.ntf_action_button_radius')
  private size: Resource = $r('app.float.ntf_small_icon_size');
  private entry: NotificationEntry | undefined = undefined;
  private onErrorEvent: (() => void) | undefined = undefined;
  private hasBorder: boolean = false;
  constructor(size?: Resource, radius?: Resource, entry?: NotificationEntry, hasBorder?:boolean) {
    super();

    if (size !== undefined) {
      this.size = size;
    }

    if (radius !== undefined) {
      this.radius = radius;
    }
    this.entry = entry;

    if (hasBorder !== undefined) {
      this.hasBorder = hasBorder;
    }
  }

  setOnErrorEvent(onErrorEvent: () => void): NtfAppIconModifier {
    this.onErrorEvent = onErrorEvent;
    return this;
  }

  initializeModifier(instance: ImageAttribute) {
    instance
      .width(this.size)
      .height(this.size)
      .draggable(false)
      .syncLoad(false)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .border(this.entry?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE || !this.hasBorder ? undefined : {
        width: '1px',
        color: '#3F808080',
        radius: this.radius
      })
      .onError((error) => {
        const key = this.entry?.getGroupTypeKey();
        LogWithHa.error(log, `Load image error, key is: ${key}, message is: ${error?.message}`,
          NotificationExceptionCode.NOTIFICATION_ICON_ERROR, undefined, key);
        if (this.onErrorEvent) {
          this.onErrorEvent();
        }
      })
      .onComplete((event) => {
        log.showWarn(`Load complete, key is: ${this.entry?.getGroupTypeKey()}, status is: ${event?.loadingStatus}`)
      })
  }
}
