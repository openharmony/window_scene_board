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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from './GridLayoutItemInfo';

const TAG = 'Extend1Data';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * GridLayoutItemInfo extend1数据
 */
export class Extend1Data {
  public parameters?: Map<string, object | undefined>;

  /**
   * 从extend1字段中取出CardSourceType
   * @param extend1 GridLayoutItemInfo中extend1的值
   * @returns
   */
  public static getCardSourceType(extend1: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(extend1)) {
      return '';
    }
    let params: Extend1Data = Extend1Data.parseExtend1(extend1);
    if (!params.parameters) {
      params.parameters = new Map<string, object | undefined>();
    }
    return params.parameters[Extend1DataKey.OHOS_EXTRA_PARAM_KEY_SOURCE_TYPE] ?? '';
  }

  /**
   * 设置extend1中的卡片来源值
   * @param itemInfo 桌面布局数据
   * @param sourceType 卡片来源，见CardSourceType类
   */
  public static setCardSourceType(itemInfo: GridLayoutItemInfo, sourceType: string): void {
    if (!itemInfo) {
      log.showWarn('set card source type failed, layout info is invalid');
      return;
    }
    let params: Extend1Data = Extend1Data.parseExtend1(itemInfo.extend1 ?? '');
    if (!params.parameters) {
      params.parameters = new Map<string, object | undefined>();
    }
    params.parameters[Extend1DataKey.OHOS_EXTRA_PARAM_KEY_SOURCE_TYPE] = sourceType;
    itemInfo.extend1 = JSON.stringify(params);
  }

  /**
   * 设置extend1中卡片的迁移key值
   * @param extend1
   * @returns
   */
  public static setMigrateForm(extend1: string): string {
    let params: Extend1Data = Extend1Data.parseExtend1(extend1);
    if (!params.parameters) {
      params.parameters = new Map<string, object | undefined>();
    }
    params.parameters[Extend1DataKey.OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM] = true;
    return JSON.stringify(params);
  }

  public static unsetMigrateForm(extend1: string): string {
    let params: Extend1Data = Extend1Data.parseExtend1(extend1);
    if (params.parameters) {
      params.parameters[Extend1DataKey.OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM] = undefined;
    }
    return JSON.stringify(params);
  }

  private static parseExtend1(extend1: string): Extend1Data {
    if (CheckEmptyUtils.checkStrIsEmpty(extend1)) {
      log.showWarn(`parseExtend1 extend1 checkStrIsEmpty`);
      return new Extend1Data();
    }
    let params: Extend1Data;
    try {
      params = JSON.parse(extend1);
      if (CheckEmptyUtils.isEmpty(params) || typeof (params) !== 'object') {
        log.showError(`parse error extend1: ${extend1} params: ${params} type: ${typeof (params)}`);
        params = new Extend1Data();
      }
    } catch (e) {
      log.showError('parse itemInfo extend1 failed, extend1=%{public}s, message:%{public}s, name:%{public}s',
        extend1, e?.message, e?.name);
      params = new Extend1Data();
    }
    return params;
  }
}

export class Extend1DataKey {
  /**
   * form require params
   */
  public static readonly OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM = 'ohos.extra.param.key.migrate_form';

  /**
   * form source type
   * 有效值见CardSourceType,值为空时表示未定义
   */
  public static readonly OHOS_EXTRA_PARAM_KEY_SOURCE_TYPE = 'ohos.extra.param.key.source_type';
}

export const enum CardSourceType {
  // 系统预置
  SYS_PRESETS = '1',
  // 用户添加
  USER_ADD = '2',
  // 升级
  UPGRADE_MIGRATE = '3',
  // 克隆
  CLONE_MIGRATE = '4',
}

export enum Extend1DataKeyEnum {
  /**
   * form require params
   */
  OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM = 'ohos.extra.param.key.migrate_form',

  /**
   * form source type
   * 有效值见CardSourceType,值为空时表示未定义
   */
  OHOS_EXTRA_PARAM_KEY_SOURCE_TYPE = 'ohos.extra.param.key.source_type'
}

export interface IExtend1DataKey {
  OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM: number;
}