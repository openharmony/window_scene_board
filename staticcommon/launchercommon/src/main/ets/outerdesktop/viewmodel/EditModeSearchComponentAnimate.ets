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

import { curves } from '@kit.ArkUI';
import { EditModeConstants} from '../../TsIndex';
import { EditModeSearchComponentData } from './EditModeSearchComponentData';
import { GlobalContext } from '@ohos/frameworkwrapper';

export class EditModeSearchComponentAnimate {
  private mData: EditModeSearchComponentData;

  constructor(mData: EditModeSearchComponentData) {
    this.mData = mData;
  }

  /**
   * 切换标题栏动效
   */
  public toggleTitleBarAction(): void {
    animateTo({ duration: EditModeConstants.OUTER_SEARCH_BACK_ACTION_DURATION
    , curve: curves.cubicBezierCurve(0.17, 0, 0.83, 1), onFinish: () => {
        this.mData.titleSearchVisible = Visibility.None;
      }}, () => {
      this.mData.titleSearchOpacity = 0;
    })
    animateTo({ duration: EditModeConstants.OUTER_TITLE_SHOW_ACTION_DURATION
    , curve: curves.cubicBezierCurve(0.17, 0, 0.83, 1) }, () => {
      this.mData.titleTextVisible = Visibility.Visible;
      this.mData.titleTextOpacity = 1;
    })
  }

  /**
   * 切换搜索栏动效
   */
  public toggleSearchBarAction(): void {
    animateTo({ duration: EditModeConstants.OUTER_TITLE_TO_SEARCH_DURATION, onFinish: () => {
      this.mData.titleTextVisible = Visibility.None;
    }}, () => {
      this.mData.titleTextOpacity = 0;
    })
    animateTo({ duration: EditModeConstants.OUTER_SEARCH_SHOW_ACTION_DURATION }, () => {
      this.mData.titleSearchVisible = Visibility.Visible;
      this.mData.titleSearchOpacity = 1;
      GlobalContext.getContext()?.eventHub.emit(EditModeConstants.OUTER_SET_REQUEST_FOCUS);
    })
  }
}