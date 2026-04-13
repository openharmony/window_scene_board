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
import { EditSearchComponentParam } from '../viewmodel/EditSearchComponentData';
import { EditSearchComponent } from './EditSearchComponent';
import { LengthMetrics } from '@kit.ArkUI';
import EditModeConstants from '../../utils/EditModeConstants';
import {
  EditModeSearchComponentEvent,
  EditModeSearchOptions,
} from '../viewmodel/EditModeSearchComponentEvent';
import { EditModeSearchComponentData } from '../viewmodel/EditModeSearchComponentData';

/**
 * 小折叠外屏应用中心,卡片中心,上方标题栏
 */
@Component
export struct EditModeSearchComponent {
  @State mData: EditModeSearchComponentData = new EditModeSearchComponentData();
  @State mEvent: EditModeSearchComponentEvent = new EditModeSearchComponentEvent();
  @State titleName: string | Resource = '';
  private mSearchComponentParam: EditSearchComponentParam = new EditSearchComponentParam();
  private mEditModeSearchOptions: EditModeSearchOptions = new EditModeSearchOptions();
  private isForm: boolean = false;

  aboutToAppear(): void {
    this.mData.initData(this.titleName, this.mSearchComponentParam, this.mEditModeSearchOptions, this.isForm);
    this.mEvent.initData(this.mData);
    // 注册初始化参数事件
    GlobalContext.getContext()?.eventHub.on(EditModeConstants.OUTER_RESET_SEARCH_COMPONENT, () => {
      this.mEvent.resetEditModeSearchComponent();
    });
    // 注册返回title事件
    GlobalContext.getContext()?.eventHub.on(EditModeConstants.OUTER_RETURN_TO_TITLE, () => {
      this.mEvent.backButtonOnclick();
    });
  }

  aboutToDisappear(): void {
    // 注销初始化参数事件
    GlobalContext.getContext()?.eventHub.off(EditModeConstants.OUTER_RESET_SEARCH_COMPONENT);
    // 注销返回title事件
    GlobalContext.getContext()?.eventHub.off(EditModeConstants.OUTER_RETURN_TO_TITLE);
  }

  @Styles
  buttonIconStyle() {
    .width(EditModeConstants.OUTER_BUTTON_ICON_SIZE)
    .height(EditModeConstants.OUTER_BUTTON_ICON_SIZE)
  }

  @Styles
  buttonSizeStyle() {
    .width(EditModeConstants.OUTER_BUTTON_SIZE)
    .height(EditModeConstants.OUTER_BUTTON_SIZE)
  }

  /**
   * 自定义搜索栏 包含返回图标和搜索栏
   */
  @Builder
  titleSearchBuilder() {
    RelativeContainer() {
      Button({ type: ButtonType.Circle }) {
        Image($r('sys.media.ohos_ic_compnent_titlebar_back'))
          .matchTextDirection(true)
          .buttonIconStyle()
          .draggable(false)
          .fillColor($r('sys.color.ohos_id_color_primary'))
      }
      .id('back_button')
      .backgroundColor($r('app.color.media_control_default_img_bgc'))
      .buttonSizeStyle()
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        start: { anchor: 'close_button', align: HorizontalAlign.Start }
      })
      .accessibilityText($r('app.string.back'))
      .onClick(this.mEvent.backButtonOnclick)
      // 搜索栏
      EditSearchComponent({ mSearchComponentParam: this.mData.mSearchComponentParam, isForm: this.mData.isForm })
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          start: { anchor: 'back_button', align: HorizontalAlign.End }
        })
        .width(EditModeConstants.OUTER_SEARCH_WIDTH)
        .height(EditModeConstants.OUTER_SEARCH_HEIGHT)
        .margin({ start: LengthMetrics.vp(EditModeConstants.OUTER_SEARCH_MARGIN) })
    }
    .width('100%')
    .height('100%')
    .visibility(this.mData.titleSearchVisible)
    .opacity(this.mData.titleSearchOpacity)
  }

  /**
   * 自定义标题 包含title 搜索图标 关闭图标
   */
  @Builder
  titleTextBuilder() {
    RelativeContainer() {
      Text(this.mData.titleName)
        .draggable(false)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          start: {anchor: '__container__', align: HorizontalAlign.Start}
        })

      Button({ type: ButtonType.Circle} ) {
        SymbolGlyph($r('sys.symbol.magnifyingglass'))
          .buttonIconStyle()
          .fontSize(EditModeConstants.OUTER_BUTTON_ICON_SIZE + 'vp')
          .draggable(false)
          .fontColor([$r('sys.color.ohos_id_color_primary')])
      }
      .buttonSizeStyle()
      .backgroundColor($r('app.color.media_control_default_img_bgc'))
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        end: { anchor: 'close_button', align: HorizontalAlign.Start }
      })
      .margin({ end: LengthMetrics.vp(EditModeConstants.OUTER_SEARCH_MARGIN) })
      .accessibilityText($r('app.string.search'))
      .onClick(() => {
        this.mEvent.searchButtonOnClick();
      })

      Button({ type: ButtonType.Circle} ) {
        SymbolGlyph($r('sys.symbol.xmark'))
          .buttonIconStyle()
          .fontSize(EditModeConstants.OUTER_BUTTON_ICON_SIZE + 'vp')
          .draggable(false)
          .fontColor([$r('sys.color.ohos_id_color_primary')])
      }
      .backgroundColor($r('app.color.media_control_default_img_bgc'))
      .id('close_button')
      .buttonSizeStyle()
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        end: {anchor: '__container__', align: HorizontalAlign.End}
      })
      .accessibilityText($r('app.string.back'))
      .onClick(() => {
        this.mEvent.closeButtonOnClick();
      })
    }
    .width('100%')
    .height('100%')
    .opacity(this.mData.titleTextOpacity)
    .visibility(this.mData.titleTextVisible)
  }

  build() {
    RelativeContainer() {
      this.titleTextBuilder();
      this.titleSearchBuilder();
    }
    .width('100%')
    .height('100%')
  }
}