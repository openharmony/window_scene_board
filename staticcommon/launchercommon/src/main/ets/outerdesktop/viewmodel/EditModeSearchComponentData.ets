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

import { EditSearchComponentParam, EditSearchStateMgr } from './EditSearchComponentData';
import { EditModeSearchOptions } from './EditModeSearchComponentEvent';

@Observed
export class EditModeSearchComponentData {
  // 搜索状态管理器
  public mSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();
  // 搜索栏透明度
  public titleSearchOpacity: number = 0;
  // 标题透明度
  public titleTextOpacity: number = 1;
  // 搜索栏显示状态
  public titleSearchVisible: number = Visibility.None;
  // 标题显示状态
  public titleTextVisible: number = Visibility.Visible;
  // 标题名
  public titleName: string | Resource = '';
  // 搜索参数
  public mSearchComponentParam: EditSearchComponentParam = new EditSearchComponentParam();
  // 搜索点击事件参数
  public mEditModeSearchOptions: EditModeSearchOptions = new EditModeSearchOptions();
  // 是否是卡片
  public isForm: boolean = false;

  /**
   * 初始化数据
   *
   * @param titleName 标题名
   * @param searchComponentParam 搜索参数
   * @param editModeSearchOptions 搜索栏点击事件参数
   * @param isForm 是否是卡片
   */
  public initData(titleName: string | Resource, searchComponentParam: EditSearchComponentParam
    , editModeSearchOptions: EditModeSearchOptions, isForm: boolean): void {
    this.titleName = titleName;
    this.mSearchComponentParam = searchComponentParam;
    this.mEditModeSearchOptions = editModeSearchOptions;
    this.isForm = isForm;
  }
}