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

import image from '@ohos.multimedia.image';
import { ParameterItem } from '../model/DockMenuCategory';
/**
 * Dock Menu category type.
 */
export enum DockMenuCategoryType {
  SYSTEM,
  USER,
}

export enum DockMenuDataType {
  TYPE_CATEGORY = 0,
  TYPE_TASK = 1
}

/**
 * Dock menu task info
 */
export class DockMenuTaskInfo {
  /**
   * 数据库id
   */
  public id: number = -1;

  /**
   * task id: 任务id
   */
  public taskId: number = 1;

  /**
   * 任务是否固定
   */
  public taskState: number = -1;

  /**
   * task name，任务名
   */
  public taskName: string = '';

  /**
   * taskIcon，任务图标，base64
   */
  public taskIcon?: string = '';

  /**
   * 上层使用的img
   */
  public taskIconImg?: image.PixelMap;

  /**
   * taskDetail，任务详情
   */
  public taskDetail?: string;

  /**
   * bundleName，任务bundleName
   */
  public bundleName: string = '';

  /**
   * moduleName，任务moduleName
   */
  public moduleName?: string;

  /**
   * 是category，还是task
   */
  public dataType: DockMenuDataType = DockMenuDataType.TYPE_CATEGORY;

  /**
   * abilityName，任务abilityName
   */
  public abilityName: string = '';

  /**
   * categoryId，分组Id
   */
  public categoryId: number = -1;

  /**
   * categoryName，分组名，要考虑多语言
   */
  public categoryName: string = '';

  /**
   * categoryType，分组类型
   */
  public categoryType: number = DockMenuCategoryType.USER;

  /**
   * create time，创建的时间，按时间排序
   */
  public createTime: number = 0;

  /**
   * The description of the WantParams string in an Want，Want参数的描述
   */
  public parametersStr?: string = '';

  /**
   * The description of the WantParams object in an Want，Want参数的描述
   */
  public parameters?: ParameterItem[] = [];
}