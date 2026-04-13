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

import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
import lazy { EditSearchComponentData } from './EditSearchComponentData';
import lazy { EditSearchState } from './EditSearchComponentData';
import { EditModeConstants } from '../../TsIndex';

export class EditSearchComponentEvent {
  private mData?: EditSearchComponentData;

  /**
   * 设置Data
   *
   * @param data data
   */
  public setData(data: EditSearchComponentData): void {
    this.mData = data;
  }

  /**
   * 搜索框聚焦事件
   */
  public searchOnFocus(): void {
    this.mData?.mSearchStateMgr.setState(EditSearchState.FOCUSED);
  }

  /**
   * 搜索框失去焦点事件
   */
  public searchOnBlur(): void {
    this.mData?.mSearchStateMgr.setState(CheckEmptyUtils.checkStrIsEmpty(this.mData?.mSearchValue) ?
    EditSearchState.NONE : EditSearchState.EDITED);
  }

  /**
   * 搜索框提交事件
   *
   * @param value 搜索框内容
   */
  public searchOnSubmit(value: string): void {
    this.mData?.onSearchValueChange(value);
  }

  /**
   * 搜索框内容修改事件
   *
   * @param value 搜索框内容
   */
  public searchOnChange(value: string): void {
    this.mData?.onSearchValueChange(value);
    if (this.mData?.isForm) {
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.SET_FORM_SEARCH_VALUE, this.mData?.mSearchValue);
    }
  }
}