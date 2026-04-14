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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppIconData } from '../../../../launchericon/viewmodel/AppIconData';
import { ATTRIBUTE_TYPE } from '../FolderCommonConstant';
import { BaseObserver } from './BaseObserver';
import { FolderIconObserverImpl } from './FolderIconObserverImpl';

const TAG: string = 'FolderIconObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INVALID_VALUE = 0;

/**
 * 文件夹图标属性状态变量更新
 */
export class FolderIconObserver extends BaseObserver implements FolderIconObserverImpl {
  public appIcon: AppIconData = new AppIconData();

  /**
   * 初始化图标的状态变量集合
   *
   * @param iconData 图标状态变量集合
   */
  public setIconData(iconData: AppIconData): void {
    this.appIcon = iconData;
  }

  /**
   * 更新属性
   *
   * @param type 属性类型
   * @param value 更新值
   */
  public setAttribute(type: number, value: number): void {
    switch (type) {
      case ATTRIBUTE_TYPE.OPACITY:
        this.appIcon.iconOpacity = value;
        break;
      case ATTRIBUTE_TYPE.SCALE_X:
        this.appIcon.iconScale = value;
        break;
      case ATTRIBUTE_TYPE.SCALE_Y:
        this.appIcon.iconScale = value;
        break;
      case ATTRIBUTE_TYPE.TRANS_X:
        this.appIcon.transX = value;
        break;
      case ATTRIBUTE_TYPE.TRANS_Y:
        this.appIcon.transY = value
        break;
      case ATTRIBUTE_TYPE.OFFSET_X:
        this.offsetX = value;
        break;
      case ATTRIBUTE_TYPE.OFFSET_Y:
        this.offsetY = value;
        break;
      case ATTRIBUTE_TYPE.SCALE:
        this.appIcon.iconScale = value;
        break;
      default:
        log.showError('update attribute for type %{public}d error', type);
        break;
    }
  }

  /**
   * 获取属性值
   *
   * @param type 属性类型
   * @returns
   */
  public getAttribute(type: number): number {
    switch (type) {
      case ATTRIBUTE_TYPE.OPACITY:
        return this.appIcon.iconOpacity;
      case ATTRIBUTE_TYPE.SCALE_X:
        return this.appIcon.iconScale;
      case ATTRIBUTE_TYPE.SCALE_Y:
        return this.appIcon.iconScale;
      case ATTRIBUTE_TYPE.TRANS_X:
        return this.appIcon.transX;
      case ATTRIBUTE_TYPE.TRANS_Y:
        return this.appIcon.transY;
      case ATTRIBUTE_TYPE.OFFSET_X:
        return this.offsetX;
      case ATTRIBUTE_TYPE.OFFSET_Y:
        return this.offsetY;
      case ATTRIBUTE_TYPE.SCALE:
        return this.appIcon.iconScale;
      default:
        log.showError('get attribute for type %{public}d error', type);
        break;
    }
    return INVALID_VALUE;
  }

  /**
   * 动效结束后重置appIconObserver属性
   */
  public finish(): void {
    this.appIcon.isShowMask = false;
  }
}