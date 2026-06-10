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

import rdb from '@ohos.data.rdb';
import { CheckEmptyUtils } from '@ohos/basicutils';
import GridLayoutInfoColumns from './GridLayoutInfoColumns';

/**
 * 桌面壳应用及图标位置映射
 */
export interface GridLayoutMapReplaceInfo {
  /**
   * 映射类型
   * @see MappingTypeConstants
   */
  mappingType: number[];

  /**
   * 所有旧的包名信息，可能有多个
   */
  oldInfo: GridLayoutInfo[];

  /**
   * 新包名
   */
  newInfo: GridLayoutInfo;
}

/**
 * 文件对象
 * @see GRID_LAYOUT_MAP_REPLACE_INFO_CONST
 */
export class GridLayoutMapReplaceFile {
  public maps: GridLayoutMapReplaceInfo[] = [];
}

/**
 * 文件基础数据
 */
export class MetaData {
  // 版本从1自增,每次修改+1
  public version: number = 1;
}

/**
 * 映射类型
 */
export class MappingTypeConstants {
  /**
   * 应用和分身
   */
  public static TYPE_APP: number = 0;

  /**
   * 卡片
   */
  public static TYPE_CARD: number = 1;

  /**
   * 快捷方式
   */
  public static TYPE_SHORTCUT: number = 7;
}

/**
 * 包名信息
 */
export class GridLayoutInfo {
  public bundleName: string = '';
  public moduleName: string = '';
  public abilityName: string = '';
}

/**
 * 更新数据库请求
 */
export interface UpdateGirdLayoutReq {
  /**
   * 表名
   */
  tableName: string;
  ids: number[];
  newGridLayoutInfo: GridLayoutInfo;
}

/**
 * 更新数据库工具类
 */
export class UpdateGirdLayoutReqUtil {
  /**
   * 获取更新数据
   */
  public static toValuesBucket(source: GridLayoutInfo): rdb.ValuesBucket {
    let updateBucket: rdb.ValuesBucket = {};
    if (!CheckEmptyUtils.checkStrIsEmpty(source.bundleName)) {
      updateBucket[GridLayoutInfoColumns.BUNDLE_NAME] = source.bundleName;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(source.moduleName)) {
      updateBucket[GridLayoutInfoColumns.MODULE_NAME] = source.moduleName;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(source.abilityName)) {
      updateBucket[GridLayoutInfoColumns.ABILITY_NAME] = source.abilityName;
    }
    return updateBucket;
  }
}

export class TempGridLayoutInfo {
  public id: number = 0;
  public typeId: number = 0;
  public bundleName: string = '';
  public moduleName: string = '';
  public abilityName: string = '';
  public page: number = 0;
  public row: number = 0;
  public column: number = 0;
  public container: number = 100;
}

/**
 * 映射文件常量
 * 如增加mappingType， 需修改 GridLayoutDBMapReplaceCorrector.ALLOW_MAPPING_TYPE_LIST
 */
export const GRID_LAYOUT_MAP_REPLACE_INFO_CONST: GridLayoutMapReplaceFile =
  {
    maps: [
      {
        mappingType: [MappingTypeConstants.TYPE_APP],
        oldInfo: [
          {
            bundleName: 'com.ohos.filemanager',
            moduleName: 'pc',
            abilityName: 'MainAbility'
          }
        ],
        newInfo: {
          bundleName: 'com.ohos.files',
          moduleName: 'entry',
          abilityName: 'EntryAbility'
        }
      },
    ]
  };