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

import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import { ViewData } from '../../../default/viewmodel/FormCenterObservedData'
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel'
import { ContentParam, FormCenterContentBuilderInterface } from '../../interfaces/FormCenterContentBuilderInterface';
import { BindSheetStateData } from '../../viewmodel/data/BindSheetStateData'
import { NavEvent } from '../../viewmodel/event/NavEvent';
import { FormCenterLayoutEventFactory } from '../../viewmodel/factory/FormCenterLayoutEventFactory'
import { FormCenterSplitView } from './FormCenterSplitView'
import { FormCenterStackView } from './FormCenterStackView'
import { FormCenterViewStyle } from '../../viewstyles/FormCenterViewStyle';
import { FormCenterSplitViewStyle } from '../../viewstyles/FormCenterSplitViewStyle';
import { FormCenterStackViewStyle } from '../../viewstyles/FormCenterStackViewStyle';

export class FormCenterContentWrapper implements FormCenterContentBuilderInterface {
  public buildView(): WrappedBuilder<ContentParam[]> {
    return wrapBuilder(formCenterContentBuilder);
  }
}

@Builder
function formCenterContentBuilder($$: ContentParam) {
  FormCenterContentView({
    mViewData: $$.mViewData,
    mAppInfoList: $$.mAppInfoList,
    openHighIndexView: $$.openHighIndexView,
    bindSheetStateData: $$.bindSheetStateData,
    style: $$.style,
  })
}

@Component
export struct FormCenterContentView {
  public mFormCenterViewModel: FormCenterViewModel = FormCenterViewModel.getInstance();
  public bindSheetStateData: BindSheetStateData = new BindSheetStateData();
  public mRecommendedCardList: CardItemInfo[] = [];
  public openHighIndexView: boolean = false;
  public style?: FormCenterViewStyle;
  @State mViewData: ViewData = new ViewData();
  @State mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();

  build() {
    if (this.bindSheetStateData.isSupportSplit) {
      FormCenterSplitView({
        mViewData: this.mViewData,
        mAppInfoList: this.mAppInfoList,
        mRecommendedCardList: this.mRecommendedCardList,
        mEvent: new NavEvent(),
        style: this.style?.splitViewStyle ?? new FormCenterSplitViewStyle(),
      })
    } else {
      FormCenterStackView({
        mViewData: this.mViewData,
        mAppInfoList: this.mAppInfoList,
        mEvent: FormCenterLayoutEventFactory.createEvent({
          openHighIndexView: this.openHighIndexView,
          appList: this.mFormCenterViewModel.getAppList(),
        }),
        style: this.style?.stackViewStyle ?? new FormCenterStackViewStyle(),
      })
    }
  }
}