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
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/plugin/info/StatusBarType';
import { StatusBarTint } from '../common/StatusBarTint';
import { collections } from '@kit.ArkTS';
import { EnvVm } from '@ohos/systemuicommon/newIndex';

'use shared';

@Sendable
export class StatusBarColorData {
  private static data: StatusBarColorData | undefined;

  public static instance(): StatusBarColorData {
    if (!StatusBarColorData.data) {
      StatusBarColorData.data = new StatusBarColorData();
    }
    return StatusBarColorData.data;
  }

  public forceColor?: string;

  private statusBarContentColorMap: collections.Map<number, string> = new collections.Map([
    [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE],
    [StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE]
  ]);

  public getContentColor(statusBarType: number): string {
    if (this.forceColor) {
      return this.forceColor;
    }
    if (EnvVm.instance.isLockEditor) {
      return StatusBarTint.CONTENT_COLOR_WHITE;
    }
    if (!this.statusBarContentColorMap.has(statusBarType)) {
      return StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE;
    }
    const contentColor: string = this.statusBarContentColorMap.get(statusBarType)!;
    return contentColor;
  }

  public setContentColor(statusBarType: number, contentColor: string): boolean {
    if (!this.statusBarContentColorMap.has(statusBarType)) {
      return false;
    }
    this.statusBarContentColorMap.set(statusBarType, contentColor);
    return true;
  }
}