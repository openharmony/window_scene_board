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
import { SysTypeCode } from '../common/LiveConstants';
import { LiveViewData } from '../data/LiveViewData';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';

/**
 * 实况数据排序优先级
 */
export enum LiveSortPriority {
  /**
   * 录屏类
   */
  SCREEN_RECORDER = 0,
  /**
   * 通话
   */
  PHONE = 1,
  /**
   * 普通进度类
   */
  NORMAL = 2,
  /**
   * 其余长时
   */
  PERSISTENT = 3,
}

/**
 * 实况数据处理辅助工具
 */
export class LiveViewHelper {
  /**
   * 获取实况数据对应的排序优先级
   *
   * @param entry 实况数据
   * @returns 排序优先级
   */
  static getLiveEntryPriority(entry?: LiveViewData): LiveSortPriority {
    if (entry?.sysTypeCode === SysTypeCode.PHONE) {
      return LiveSortPriority.PHONE;
    }
    if (SystemUICcmConfig.instance.isEnabledLive2 && entry?.sysTypeCode === SysTypeCode.SCREEN_RECORDING) {
      return LiveSortPriority.SCREEN_RECORDER;
    }
    return LiveSortPriority.NORMAL;
  }

  /**
   * 实况数据排序
   *
   * @param entryA 待比较数据
   * @param entryB 待比较数据
   * @returns 结果
   */
  static sortLiveEntry(entryA?: LiveViewData, entryB?: LiveViewData): number {
    // 优先判断数据优先级
    let priorityA = LiveViewHelper.getLiveEntryPriority(entryA);
    let priorityB = LiveViewHelper.getLiveEntryPriority(entryB);
    if (priorityA !== priorityB) {
      return priorityA - priorityB;
    }

    // 优先级一致，则比较创建时间，时间越大越靠前
    let createTimeA = entryA?.createTime ?? 0;
    let createTimeB = entryB?.createTime ?? 0;
    return createTimeB - createTimeA;
  }

  /**
   * 是否为录屏胶囊
   *
   * @param entry 实况数据
   * @returns true录屏胶囊
   */
  static isScreenRecordCapsule(entry: LiveViewData): boolean {
    return entry?.isSysTypeCode(SysTypeCode.SCREEN_RECORDING) ?? false;
  }
}