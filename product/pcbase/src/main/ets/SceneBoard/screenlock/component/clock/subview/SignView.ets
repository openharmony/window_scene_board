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
import { IThemeParam } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { BusinessError } from '@kit.BasicServicesKit';
import AdminManagerModel from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/AdminManagerModel';
import { IUserData } from '@ohos/screenlockcommon';

const TAG = 'ScreenLock-SignView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct SignView {
  @Prop themeClockParam: IThemeParam;
  @Prop enterpriseSignatureText: string;
  @Prop @Watch('onSignatureTextChanged') signatureText: string;
  @Prop @Watch('onSignatureTextChanged') signatureVisible: boolean;

  aboutToAppear(): void {
    AdminManagerModel.getInstance().getEnterpriseDeviceSignatureText().then((data) => {
      if (data !== '') {
        this.enterpriseSignatureText = data;
        if (this.isSignatureTextShow()) {
          this.enterpriseSignatureText = this.enterpriseSignatureText + ' - ' + this.signatureText;
        }
      }
      let currentUser: IUserData | undefined = AppStorage.get<IUserData>('currentUserItem');
      if (currentUser?.userId !== 100 && !currentUser?.isDomain) {
        this.enterpriseSignatureText = '';
      }
    }).catch((err: BusinessError) => {
      log.showError(`getEnterpriseDeviceSignatureText failed! err.code: ${err.code}`);
    });
  }

  private isSignatureTextShow(): boolean {
    return this.signatureText !== '' && this.signatureVisible;
  }

  private onSignatureTextChanged(): void {
    AdminManagerModel.getInstance().getEnterpriseDeviceSignatureText().then(currentEnterpriseSignatureText => {
      if (currentEnterpriseSignatureText !== '') {
        this.enterpriseSignatureText = currentEnterpriseSignatureText;
        if (this.isSignatureTextShow()) {
          this.enterpriseSignatureText = currentEnterpriseSignatureText + ' - ' + this.signatureText;
        }
      }
    }).catch((err: BusinessError) => {
      log.showError(`getEnterpriseDeviceSignatureText failed! err.code: ${err.code}`);
    })
  }

  build() {
    if (this.enterpriseSignatureText && this.enterpriseSignatureText !== '' || this.isSignatureTextShow()) {
      Marquee({
        start: true,
        step: 2,
        src: (this.enterpriseSignatureText ? this.enterpriseSignatureText : this.signatureText)?.slice(0, 200)
      })
        .fontColor(this.themeClockParam.color)
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontFamily(this.themeClockParam.fontFamily)
        .height($r('app.float.edit_clockwidget_signature_4_2_height'))
        .align(Alignment.Center)
        .margin({ top: $r('app.float.edit_clockwidget_signature_margin_top') })
    }
  }
}

