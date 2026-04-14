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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants, EditModeConstants } from '@ohos/launchercommon';
import { FormCenterViewEvent } from './FormCenterViewEvent';
import {
  EditSearchStateMgr,
  EditSearchState,
  EditSearchShowState,
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditSearchComponentData';
import { EditModeSearchOptions } from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditModeSearchComponentEvent';
import { OuterCenterTitleWrapper } from '../../../view/atomicview/formcentertitle/OuterFormCenterTitle';
import { FormCenterTitleParam, CenterTitleBuilderInterface } from '../../../interfaces/FormCenterTitleBuildeInterface';

const TAG = 'OuterFormCenterViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class OuterFormCenterViewEvent extends FormCenterViewEvent {
  private mEditSearchStateMgr: EditSearchStateMgr = EditSearchStateMgr.getInstance();

  public backGestureHandler(): void {
    if (!this.bindSheetStateData.isShow) {
      return;
    }

    log.showInfo(`backGesture Handler By Outer searchState: ${this.mEditSearchStateMgr.getState()}`);
    // 获焦状态下，只关闭键盘
    if (this.mEditSearchStateMgr.getState() === EditSearchState.FOCUSED) {
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.CLOSE_KEY_BOARD_OF_OUTER_EDIT_CENTER);
      return;
    }
    // 搜索框有内容，清除搜索框,返回标题栏
    if (this.mEditSearchStateMgr.getShowState() === EditSearchShowState.SHOW) {
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_DATA);
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_RETURN_TO_TITLE);
      return;
    }
    // 退出页面
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_FORM_MANAGER_EXIT);
    log.showInfo('backGestureHandlerByOuter deal backGestureHandler');
    this.bindSheetStateData.isShow = false;
    this.mSearchStateMgr.setIsShowSearchResult(false);
  }

  getTitleBuilder(): CenterTitleBuilderInterface {
    return new OuterCenterTitleWrapper();
  }

  getTitleBuilderParam(): FormCenterTitleParam {
    return {
      text: ResUtils.getInnerStringNumS($r('app.string.add_form_to_desktop')),
      mEditModeSearchOptions: this.getEditModeSearchOptions(),
    };
  }

  protected showHideView(): void {
    super.showHideView();
    //小折叠外屏显示搜索栏,回到卡片中心页面时需要设置搜索栏焦点
    if (this.mEditSearchStateMgr.getShowState() === EditSearchShowState.SHOW) {
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_SET_REQUEST_FOCUS);
    }
  }

  protected destroyViewData(): void {
    super.destroyViewData();
    GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_COMPONENT);
  }


  // 搜索按钮点击事件
  private searchIconOnClick(): void {
    log.showInfo('searchIconOnClick');
    this.mEditSearchStateMgr.setShowState(EditSearchShowState.SHOW);
    this.mSearchStateMgr.setIsShowSearchResult(true);
  }

  // 返回按钮点击事件
  private backIconOnClick(): void {
    log.showInfo('backIconOnClick');
    this.mEditSearchStateMgr.setShowState(EditSearchShowState.NOT_SHOW);
    GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_RESET_SEARCH_DATA);
    this.mSearchStateMgr.setIsShowSearchResult(false);
  }

  // 初始化各个按钮点击事件
  public getEditModeSearchOptions(): EditModeSearchOptions {
    let editModeSearchOptions: EditModeSearchOptions = new EditModeSearchOptions();
    editModeSearchOptions.searchIconOnClick = () => this.searchIconOnClick();
    editModeSearchOptions.backIconOnClick = () => this.backIconOnClick();
    editModeSearchOptions.closeIconOnClick = () => this.closeView();
    return editModeSearchOptions;
  }
}