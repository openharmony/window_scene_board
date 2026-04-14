/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import inputMethodUtil from './SCBInputMethodUtil';
import { SCBInputMethodList } from './SCBInputMethodList';
import { SCBSmartList } from './SCBSmartList';
import { SCBScreenProperty, SCBKeyboardPanelSession } from '@ohos/windowscene';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';

const NORMAL_DIALOG_WIDTH: number = 224;
const FLOAT_DIALOG_WIDTH: number = 182;
const LIST_IMAGE_SIZE: number = 24;
const FLOAT_LIST_IMAGE_SIZE: number = 20;

class DialogStyle {
  public listPadding: number = 4;
  public listRadius: Resource = $r('sys.float.ohos_id_corner_radius_menu');
  public listWidth: number = NORMAL_DIALOG_WIDTH;
  public listItemRadius: number = 16;
  public listItemPadding: number = 12;
  public listItemHeight: number = 48;
  public listImageSize: string = inputMethodUtil.getScaleSize(LIST_IMAGE_SIZE);
  public listFontSize: string = inputMethodUtil.getScaleSize($r('sys.float.ohos_id_text_size_body1'));
  public listFontWeight: Resource = $r('sys.string.ohos_id_text_font_family_medium');
  public imageBtnWidth: number = 40;
  public imageBtnHeight: number = 32;
  public imageRadius: number = 8;
  public imageMargin: number = 8;
  public listItemColor: Resource = $r('app.color.keyboard_item_item_bg_color');

  public initFloatStyle(): void {
    this.listWidth = FLOAT_DIALOG_WIDTH;
    this.listItemHeight = 40;
    this.listPadding = 3;
    this.imageMargin = 6;
    this.listItemPadding = 10;
    this.listImageSize = inputMethodUtil.getScaleSize(FLOAT_LIST_IMAGE_SIZE);
    this.listFontSize = inputMethodUtil.getScaleSize($r('sys.float.ohos_id_text_size_body2'));
  }

  public initNormalStyle(): void {
    this.listWidth = NORMAL_DIALOG_WIDTH;
    this.listItemHeight = 48;
    this.listItemPadding = 12;
    this.listPadding = 4;
    this.imageMargin = 8;
    this.listImageSize = inputMethodUtil.getScaleSize(LIST_IMAGE_SIZE);
    this.listFontSize = inputMethodUtil.getScaleSize($r('sys.float.ohos_id_text_size_body1'));
  }
}
export let dialogStyle = new DialogStyle();


@Component
export struct SCBKeyboardDialog {
  @Link screenProperty: SCBScreenProperty;
  @Link dialogType: string;
  @Link isShowDialog: boolean;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @State listMaxNum: number = 0;
  private gravity: sceneSessionManager.KeyboardGravity = sceneSessionManager.KeyboardGravity.GRAVITY_BOTTOM;

  aboutToAppear(): void {
    if (this.gravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT) {
      this.listMaxNum = 4;
      dialogStyle.initFloatStyle();
    } else {
      this.listMaxNum = 0;
      dialogStyle.initNormalStyle();
    }
  }

  build() {
    Column() {
      if (this.dialogType === 'left') {
        SCBInputMethodList({
          listMaxNum: $listMaxNum,
          isShowDialog: $isShowDialog,
          keyboardPanelSession: this.keyboardPanelSession
        })
      } else {
        SCBSmartList({
          isShowDialog: $isShowDialog,
          keyboardPanelSession: this.keyboardPanelSession,
          gravity: this.gravity
        })
      }
    }
    .width(dialogStyle.listWidth)
    .margin({ top: 8 })
  }
}