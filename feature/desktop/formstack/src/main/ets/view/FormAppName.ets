/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppName } from '@ohos/launchercommon/Index';
import { FormStackItemInfo } from '../common/FormStackItemInfo';

@Component
export struct FormAppName {
  private mFormStackNameSize: number = 0;
  private mNameFontColor: string = '';
  private mFormStackNameHeight: number = 0;
  private mFormStackNameWidth: number = 0;
  private mNameLines: number = 0;
  private mIconNameMargin: number = 0;
  private marginLeft: number = 0;
  private getIndexInSwiper: Function = (): number => 0;
  private colStart: number = 0;
  private colEnd: number = 0;
  private rowEnd: number = 0;
  private parentItem: FormStackItemInfo = new FormStackItemInfo();

  @Link formStackAppName: string;
  @Link mOpacity: number;

  build() {
    AppName({
      appName: this.formStackAppName,
      nameSize: this.mFormStackNameSize,
      nameFontColor: this.mNameFontColor,
      nameHeight: this.mFormStackNameHeight,
      nameWidth: this.mFormStackNameWidth,
      maxLines: 1,
      nameLines: this.mNameLines,
      marginTop: this.mIconNameMargin,
      marginLeft: this.marginLeft,
      getIndexInSwiper: this.getIndexInSwiper,
      colStart: this.colStart,
      colEnd: this.colEnd,
      rowEnd: this.rowEnd,
      parentItem: this.parentItem as Object as GridLayoutItemInfo
    })
      .opacity(this.mOpacity)
      .transition(TransitionEffect.OPACITY.animation({ duration: 200, delay: 200, curve: Curve.Friction }))
  }
}