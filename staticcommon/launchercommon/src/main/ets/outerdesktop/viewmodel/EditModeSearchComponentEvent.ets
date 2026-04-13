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

import { EditModeSearchComponentData } from './EditModeSearchComponentData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EditModeSearchComponentAnimate } from './EditModeSearchComponentAnimate';

const TAG = 'EditModeSearchComponentEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class EditModeSearchOptions {
  // 搜索图标点击事件
  public searchIconOnClick: () => void = () => {};
  // 返回图标点击事件
  public backIconOnClick: () => void = () => {};
  // 关闭图标点击事件
  public closeIconOnClick: () => void = () => {};
}


export class EditModeSearchComponentEvent {
  private mData?: EditModeSearchComponentData;
  private mAnimate?: EditModeSearchComponentAnimate;

  /**
   * 初始化数据对象
   *
   * @param data 数据对象
   */
  public initData(data: EditModeSearchComponentData): void {
    this.mData = data;
    this.mAnimate = new EditModeSearchComponentAnimate(data);
  }

  /**
   * 重置搜索组件
   */
  public resetEditModeSearchComponent = () => {
    if (!this.mData) {
      log.showInfo('resetEditModeSearchComponent mData is undefined')
      return;
    }
    this.mData.titleSearchOpacity = 0;
    this.mData.titleTextOpacity = 1;
    this.mData.titleSearchVisible = Visibility.None;
    this.mData.titleTextVisible = Visibility.Visible;
  }

  /**
   * 退出按钮事件
   */
  public backButtonOnclick = () => {
    // 返回按钮功能
    this.mData?.mEditModeSearchOptions.backIconOnClick();
    // 执行切换标题栏动效
    this.mAnimate?.toggleTitleBarAction()
  };

  /**
   * 搜索按钮事件
   */
  public searchButtonOnClick = () => {
    this.mData?.mEditModeSearchOptions.searchIconOnClick();
    // 执行切换搜索栏动效
    this.mAnimate?.toggleSearchBarAction();
  }

  /**
   * 关闭按钮事件
   */
  public closeButtonOnClick = () => {
    this.mData?.mEditModeSearchOptions.closeIconOnClick();
  }
}