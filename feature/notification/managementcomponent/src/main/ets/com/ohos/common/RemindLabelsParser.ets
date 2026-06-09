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

import { LogDomain, LogHelper } from './BasicCommon';
import { DeviceHelper } from './DeviceHelper';
import { BitUtil } from './BasicCommon';
import { ResourceUtil } from './ResourceUtil';
import { SystemParameterUtil } from './SystemParameterUtil';

const TAG = 'ManagementComponent-RemindLabelsParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class RemindLabelsParser {
  private constructor() {
  }

  /**
   * 解析ANS发送过来的通知标志。以二进制位表示不同的通知方式： 0 响铃；1 锁屏；2 横幅；3 亮屏；4 振动；5 状态栏
   * 以固定顺序显示： 横幅 锁屏 响铃 振动
   * @param slotFlags ANS发送过来的通知标志
   * @returns 解析后构造的通知字串
   */
  public static parse(slotFlags: number, showBadge?: boolean): string {
    const flag = SystemParameterUtil.calcRemindModeByVibrateSupport(slotFlags);
    if (slotFlags !== flag) {
      log.showInfo('slotFlags: %{public}d, flag: %{public}d', slotFlags, flag);
    }

    let resourcesOfNtf = RemindLabelsParser.getResourcesOfNtf(flag, showBadge);
    return RemindLabelsParser.buildRemindLabel(resourcesOfNtf);
  }

  /**
   * 获取通知索引，以数组形式返回。
   */
  private static getResourcesOfNtf(slotFlags: number, showBadge?: boolean): (Resource | undefined)[] {
    let resourcesOfNtf: (Resource | undefined)[] = [];
    if (DeviceHelper.isPC()) {
      ntfPos2RemindLabelSingleForPC.forEach((element) => {
        let key = element.index;
        if (BitUtil.getStateByIdx(slotFlags, key)) {
          resourcesOfNtf.push(element.res);
        }
      });
    } else {
      ntfPos2RemindLabelSingle.forEach((element) => {
        if (element.module === 'slotFlags' && BitUtil.getStateByIdx(slotFlags, element.index)) {
            resourcesOfNtf.push(element.res);
        } else if (element.module === 'Badge' && showBadge) {
            resourcesOfNtf.push(element.res);
        }
      });
    }
    return resourcesOfNtf;
  }

  /**
   * 构造通知方式的字串
   */
  private static buildRemindLabel(resourcesOfNtf: (Resource | undefined)[]): string {
    if (resourcesOfNtf.length === 0) {
      return ResourceUtil.getStringSync($r('app.string.remind_only_notification_center')) ?? '';
    }

    return RemindLabelsParser.buildMultipleRemindLabel(resourcesOfNtf);
  }

  /**
   * 有复数通知方式的字串
   */
  private static buildMultipleRemindLabel(resourcesOfNtf: (Resource | undefined)[]): string {
    const remindLabels: string[] = [];
    resourcesOfNtf.forEach((element) => {
      remindLabels.push(element ? ResourceUtil.getStringSync(element) ?? '' : '');
    });

    if (resourcesOfNtf.length === 1) {
      return remindLabels[0] ?? '';
    }

    if (resourcesOfNtf.length === 2) {
      return ResourceUtil.getStringSync($r('app.string.splitter_format_for_2'), ...remindLabels) ?? '';
    }
    if (resourcesOfNtf.length === 3) {
      return ResourceUtil.getStringSync($r('app.string.splitter_format_for_3'), ...remindLabels) ?? '';
    }
    if (resourcesOfNtf.length === 4) {
      return ResourceUtil.getStringSync($r('app.string.splitter_format_for_4'), ...remindLabels) ?? '';
    }
    if (resourcesOfNtf.length === 5) {
      return ResourceUtil.getStringSync($r('app.string.splitter_format_for_5'), ...remindLabels) ?? '';
    }
    log.showWarn('BuildRemindLabels. labels len more than 5. please add splitter_format info.');
    return ResourceUtil.getStringSync($r('app.string.splitter_format_for_5'), ...remindLabels) ?? '';
  }
}


class NtfPos2RemindItem {
  public module?: string;
  public index?: number;
  public res?: Resource;
}

/**
 * slotFlags:
 *  * 0 响铃；1 锁屏；2 横幅；3 亮屏；4 振动；5 状态栏
 *  * 通知索引到字串的映射。这里是仅有一种通知方式的字串形式, 3亮屏/5状态栏不在通知管理界面显示
 * isBadgeOn:
 *  * 显示角标
 * 以固定顺序显示： 锁屏、横幅、角标、响铃、震动
 */
const ntfPos2RemindLabelSingle: NtfPos2RemindItem[] = [
  { module: 'slotFlags', index: 1, res: $r('app.string.lock_screen') },
  { module: 'slotFlags', index: 2, res: $r('app.string.banner') },
  { module: 'Badge', index: 0, res: $r('app.string.badge') },
  { module: 'slotFlags', index: 0, res: $r('app.string.remind_sound') },
  { module: 'slotFlags', index: 4, res: $r('app.string.ntfSoundModeOnlyVibration') },
];
/**
 * 0 响铃；1 锁屏；2 横幅；3 亮屏；4 振动；5 状态栏
 * 通知索引到字串的映射。这里是仅有一种通知方式的字串形式, 3亮屏/5状态栏不在通知管理界面显示
 * 以固定顺序显示： 横幅 响铃
 */
const ntfPos2RemindLabelSingleForPC: NtfPos2RemindItem[] = [
  { module: 'slotFlags', index: 2, res: $r('app.string.banner') },
  { module: 'slotFlags', index: 0, res: $r('app.string.remind_sound') },
];