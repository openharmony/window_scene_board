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
import { FormCenterNoticeItem } from '../../../default/view/waterfall/FormCenterNoticeItem';
import { ViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { ContentParam, FormCenterContentBuilderInterface } from '../../interfaces/FormCenterContentBuilderInterface';
import { BindSheetStateData } from '../../viewmodel/data/BindSheetStateData';
import { FormCenterViewStyle } from '../../viewstyles/FormCenterViewStyle';
import { PcFormCenterContentStyle } from '../../viewstyles/PcFormCenterContentStyle';
import { FormCenterContentView } from './FormCenterContentView';

export class PcFormCenterContentWrapper implements FormCenterContentBuilderInterface {
  public buildView(): WrappedBuilder<ContentParam[]> {
    return wrapBuilder(pcFormCenterContentBuilder);
  }
}

@Builder
function pcFormCenterContentBuilder($$: ContentParam) {
  PcFormCenterContentView({
    mViewData: $$.mViewData,
    mAppInfoList: $$.mAppInfoList,
    mRecommendedCardList: $$.mRecommendedCardList,
    openHighIndexView: $$.openHighIndexView,
    bindSheetStateData: $$.bindSheetStateData,
    formCenterStyle: $$.style
  })
}

@Component
export struct PcFormCenterContentView {
  public style: PcFormCenterContentStyle = new PcFormCenterContentStyle();
  public formCenterStyle?: FormCenterViewStyle;
  public bindSheetStateData: BindSheetStateData = new BindSheetStateData();
  public mRecommendedCardList: CardItemInfo[] = [];
  public openHighIndexView: boolean = false;
  @State mViewData: ViewData = new ViewData();
  @State mAppInfoList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
  @State isAppListShow: boolean = true;
  @StorageLink('currColorMode') currColorMode: number = 1;

  aboutToAppear(): void {
    // 分帧方案在长按菜单场景无法收到第二帧回调，采用15ms之后绘制应用列表的方案
    this.isAppListShow = false;
    setTimeout(() => {
      this.isAppListShow = true;
    }, 15);
  }

  build() {
    Column() {
      // PC布局分帧,将此布局放到15ms之后处理
      if (this.isAppListShow) {
        FormCenterContentView({
          mViewData: this.mViewData,
          mAppInfoList: this.mAppInfoList,
          mRecommendedCardList: this.mRecommendedCardList,
          openHighIndexView: this.openHighIndexView,
          bindSheetStateData: this.bindSheetStateData,
          style: this.formCenterStyle,
        })
      }
      FormCenterNoticeItem()
        .position({ bottom: 0 })
        .width(this.formCenterStyle?.bindSheetWidth ?? this.style.sheetWidth)
    }
    .height(this.formCenterStyle?.contentHeight ?? this.style.contentHeight)
  }
}