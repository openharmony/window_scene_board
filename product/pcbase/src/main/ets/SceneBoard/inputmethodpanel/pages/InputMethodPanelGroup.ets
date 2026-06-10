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

import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';

import {
  InputMethodItemType,
  InputMethodSubtypeGroup, InputMethodSubtypeInfo
} from '../common/Constants';
import InputMethodPanelItem from './InputMethodPanelItem';

@Component
export default struct InputMethodPanelGroup {
  private inputMethodSubtypeGroup: InputMethodSubtypeGroup = {
    languageLocale: '',
    subtypeList: [],
  };
  @State listLength: number = 0;
  @Link isListShow: boolean;
  @State isArrowUp: boolean = true;
  titleItemIndex: number = 0;
  showListChange? = () => {};
  isFirstItem: boolean = false;
  @StorageLink('currentInputMethodSubtype') mCurrentInputMethodSubtype: InputMethodSubtypeInfo = {
  } as InputMethodSubtypeInfo;

  aboutToAppear(): void {
    this.listLength = this.inputMethodSubtypeGroup.subtypeList.length;
    this.isArrowUp = this.isListShow;
    let titleMode: string = sSettingsUtil.getValue(this.inputMethodSubtypeGroup.languageLocale + 'LAST_CHOOSE', 'NULL');
    this.inputMethodSubtypeGroup.subtypeList.forEach((item: InputMethodSubtypeInfo, index: number) => {
      if (item.subtype?.mode === titleMode || item.subtype?.id === this.mCurrentInputMethodSubtype.subtype?.id) {
        this.titleItemIndex = index;
      }
    })
  }

  build() {
    Column() {
      if (this.listLength > 0) {
        InputMethodPanelItem({
          inputMethodItem: this.inputMethodSubtypeGroup.subtypeList[this.titleItemIndex],
          showMoreArrow: this.listLength > 1,
          isArrowUp: this.isArrowUp,
          arrowTargetChange: (): void => this.arrowTargetChange(),
          isLanguageItem: true,
          isFirstItem: this.isFirstItem,
        })
      }
      if (this.listLength > 1) {
        Column() {
          ForEach(this.inputMethodSubtypeGroup?.subtypeList, (item: InputMethodItemType) => {
            InputMethodPanelItem({
              inputMethodItem: item,
              isLanguageItem: true,
              isArrowUp: this.isArrowUp,
              isInList: true,
            })
          });
        }
        .visibility(this.isListShow ? Visibility.Visible : Visibility.None)
      }
    }
  }

  arrowTargetChange() {
    if (this.showListChange) {
      this.showListChange();
    }
    this.isArrowUp = this.isListShow;
  }
}