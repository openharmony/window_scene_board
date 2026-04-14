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

import { AttributeUpdater } from '@ohos.arkui.modifier';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AppItemInfo,
  CardItemInfo,
  CommonConstants,
  FormCenterViewManager,
  NoIconAppInfo,
  NoIconAppModel,
} from '@ohos/launchercommon';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';
import {
  FormManagerTitleParam,
  ManagerTitleBuilderInterface
} from '../../../interfaces/FormManagerSheetTitleInterface';
import { FormCenterFormCommonUtil } from '../../../viewmodel/event/FormCenterFormCommonUtil';

const TAG = 'OutFormManagerTitle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class OuterManagerTitleWrapper implements ManagerTitleBuilderInterface {
  buildTitle(): WrappedBuilder<FormManagerTitleParam[]> {
    return wrapBuilder(buildFormCenterTitle);
  }
}

@Builder
function buildFormCenterTitle($$: FormManagerTitleParam) {
  OutFormManagerTitle({
    mAppInfo: $$.appInfo ?? new AppItemInfo(),
    formItem: $$.formItem ?? new CardItemInfo(),
    textUpdater: $$.textUpdater,
  })
}

@Component
export struct OutFormManagerTitle {
  public mAppInfo: AppItemInfo = new AppItemInfo();
  public formItem: CardItemInfo = new CardItemInfo();
  public textUpdater?: AttributeUpdater<TextAttribute, TextInterface> = new AttributeUpdater();
  @State mDisplayName: string = '';

  aboutToAppear(): void {
    this.mDisplayName = this.mAppInfo.applicationName as string;
    if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(this.mAppInfo.bundleName as string)) {
      let iconInfo: NoIconAppInfo = NoIconAppModel.getInstance().updateNoIconAppInfo(this.mAppInfo.bundleName);
      this.mDisplayName = this.mAppInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE ?
        ResourceManager.getInstance().getStringByName('lock_screen') : iconInfo.label;
    } else {
      FormCenterFormCommonUtil.getResourceName(this.mDisplayName, this.formItem.displayNameId,
        'displayName', this.formItem).then((value: string) => {
        log.showInfo(`about to appear, value: ${value}`);
        this.mDisplayName = value;
      });
    }
  }

  build(){
    Row() {
      Button() {
        Image($r('sys.media.ohos_ic_compnent_titlebar_back'))
          .width(FormStyleConstants.OUTER_TITLE_BUTTON_IMAGE_WIDTH)
          .height(FormStyleConstants.OUTER_TITLE_BUTTON_IMAGE_HEIGHT)
          .fillColor($r('sys.color.ohos_id_color_titlebar_text'))
          .draggable(false)
      }
      .width(FormStyleConstants.OUTER_TITLE_BUTTON_WIDTH)
      .height(FormStyleConstants.OUTER_TITLE_BUTTON_HEIGHT)
      .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
      .accessibilityText($r('app.string.back'))
      .onClick(() => {
        FormCenterViewManager.getInstance().formCenterBackGestureHandler();
      })

      Blank().width(FormStyleConstants.OUTER_TITLE_BLANK_WIDTH).visibility(Visibility.Hidden);

      Text(this.mDisplayName)
        .id(`${TAG}_Text_${this.mDisplayName}`)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(FontWeight.Bold)
        .lineHeight(FormStyleConstants.FORM_MGR_FORM_NAME_LINE_HEIGHT)
        .maxLines(1)
        .width(FormStyleConstants.OUTER_FORM_MGR_TITLE_WIDTH)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
        .attributeModifier(this.textUpdater)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }
}