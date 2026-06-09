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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import StyleConfiguration, { EnterpriseSpaceIconStyle } from '../common/StyleConfiguration';
import { EnterpriseSpaceIconVM, EnterpriseSpaceSymbol } from '../viewModel/EnterpriseSpaceIconViewModel';
import osAccount from '@ohos.account.osAccount';

const TAG: string = 'PC-EnterpriseSpaceIconComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct EnterpriseSpaceIcon {
  private vm: EnterpriseSpaceIconVM = new EnterpriseSpaceIconVM(this);
  @State style: EnterpriseSpaceIconStyle = StyleConfiguration.getEnterpriseSpaceIconStyle();
  @State symbol: Resource = EnterpriseSpaceSymbol.PERSON;
  @Consume contentColor: string;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.vm.init();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.vm.clear();
  }

  build() {
    Row() {
      SymbolGlyph(this.symbol)
        .draggable(false)
        .width(this.style.iconWidth)
        .height(this.style.iconHeight)
        .fontSize(this.style.iconSize)
        .fontColor([this.contentColor])
        .fontWeight(FontWeight.Medium)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
