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
import { CardItemInfo } from '@ohos/launchercommon';
import { FormDescriptionVm } from '../../viewmodel/data/FormDescriptionVm';
import { FormDescriptionEventInterface } from '../../interfaces/FormDescriptionEventInterface';
import { FormDescriptionStyle } from '../../viewstyles/FormDescriptionStyle';
import { SearchStateMgr } from './SearchComponent';
import { SingleAppResult } from '../../util/FusionSearchUtil';

const TAG = 'FormDescription';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export default struct FormDescription {
  public style: FormDescriptionStyle = new FormDescriptionStyle();
  public formItem: CardItemInfo = new CardItemInfo();
  public index?: number;
  public formDescriptionEvent?: FormDescriptionEventInterface;
  @State disPlayNameSearchResult: string = '';
  @State formDescriptionVm: FormDescriptionVm = new FormDescriptionVm();
  @State highlightStrArr: string[] = [];
  @Prop @Watch('refreshSearchResult') freshFlag: boolean = false;

  aboutToAppear(): void {
    this.formDescriptionEvent?.updateFormDescriptionVm(this.formDescriptionVm, this.formItem);
    this.refreshSearchResult();
  }

  private refreshSearchResult(): void {
    let searchStateMgr: SearchStateMgr = SearchStateMgr.getInstance();
    let isShowSearch: boolean = searchStateMgr.getIsShowSearchResult();
    if (isShowSearch) {
      let searchResult: SingleAppResult | undefined = searchStateMgr.parsedSearchResult.get(this.formItem.bundleName);
      this.disPlayNameSearchResult = searchResult?.descriptionMap.get(this.formItem.cardName) ?? '';
      this.highlightStrArr = this.disPlayNameSearchResult.split(/(<em>|<\/em>)/i);
    }
    log.showDebug(`isShowSearch: ${isShowSearch}, result: ${this.disPlayNameSearchResult}`);
  }

  build() {
    Column() {
      if (this.style.isNeedDisplayName) {
        Text(this.formDescriptionVm.mDisplayName) {
          if (this.disPlayNameSearchResult !== '') {
            ForEach(this.highlightStrArr, (str: string, index: number) => {
              if (str !== '<em>' && str !== '</em>') {
                Span(str).fontColor(this.highlightStrArr[index - 1] === '<em>' ?
                  this.style.highLightFontColor : undefined)
              }
            })
          }
        }
          .draggable(false)
          .id(`${TAG}_APPNAME[${this.index}]_${this.formDescriptionVm.mDisplayName}`)
          .fontColor(this.style.appNameFontColor)
          .fontSize(this.style.appNameFontSize)
          .fontFamily(this.style.appNameFontFamily)
          .fontWeight(this.style.appNameFontWeight)
          .lineHeight(this.style.appNameLineHeight)
          .height(this.style.appNameHeight)
          .textAlign(this.style.appNameTextAlign)
          .maxLines(this.style.appNameMaxLines)
          .textOverflow({
            overflow: this.style.appNameTextOverflow
          })
          .margin(this.style.appNameMargin)
          .padding(this.style.appNamePadding)
          .maxFontScale(this.style.maxFontScale)
      }

      if (this.style.isNeedDescription) {
        Text(this.formDescriptionVm.mDescription)
          .id(`${TAG}_FormDesc[${this.index}]_${this.formDescriptionVm.mDescription}`)
          .draggable(false)
          .fontColor(this.style.descriptionFontColor)
          .fontFamily(this.style.descriptionFontFamily)
          .fontSize(this.style.descriptionFontSize)
          .fontWeight(this.style.descriptionFontWeight)
          .lineHeight(this.style.descriptionLineHeight)
          .height(this.style.descriptionHeight)
          .textAlign(this.style.descriptionTextAlign)
          .maxLines(this.style.descriptionMaxLines)
          .textOverflow({
            overflow: this.style.descriptionTextOverflow
          })
          .margin(this.style.descriptionMargin)
          .padding(this.style.descriptionPadding)
          .maxFontScale(this.style.maxFontScale)
      }
    }
    .margin(this.style.columnMargin)
    .padding(this.style.columnPadding)
    .height(this.style.columnHeight)
    .width(this.style.columnWidth)
    .alignItems(this.style.columAlignItems)
    .accessibilityGroup(this.style.descriptionAccessibilityGroup)
    .accessibilityLevel(this.style.descriptionAccessibilityLevel ? 'yes' : 'no-hide-descendants')
  }
}