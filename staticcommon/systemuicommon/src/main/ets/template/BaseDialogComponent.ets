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

const TAG = 'BaseDialogComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_MESSAGE = TAG + '_Text_message';
const COMPONENT_ID_LEFT_BUTTON = TAG + '_Text_leftButton';
const COMPONENT_ID_RIGHT_BUTTON = TAG + '_Text_rightButton';

@CustomDialog
export default struct BaseDialogComponent {
    private title?: Resource;
    private message?: Resource;
    private leftButton?: Resource;
    private rightButton?: Resource;
    private controller?: CustomDialogController;
    private leftAction?: () => void;
    private rightAction?: () => void;
    @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;

    aboutToAppear() {
        log.showInfo('aboutToAppear');
    }

    aboutToDisappear() {
        this.controller?.close();
        log.showInfo('aboutToDisappear');
    }

    onOrientationChanged() {
        this.controller?.close();
    }

    onPageHide() {
        this.controller?.close();
    }

    build() {
        Column() {
            Text(this.title).draggable(false)
                .fontSize($r('app.float.Control_dialog_title_font_size'))
                .width('100%')
                .fontWeight(FontWeight.Medium)
                .textAlign(TextAlign.Start)
                .height($r('app.float.Control_dialog_title_height'))
                .id(COMPONENT_ID_TITLE)

            Text(this.message).draggable(false)
                .fontSize($r('app.float.Control_dialog_message_font_size'))
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({bottom: $r('app.float.Control_dialog_message_bottom_margin')})
                .id(COMPONENT_ID_MESSAGE)

            Row() {
                Button({ type: ButtonType.Capsule, stateEffect: true }) {
                    Text(this.leftButton).draggable(false)
                        .fontColor($r('sys.color.font_emphasize'))
                        .fontSize($r('sys.float.Body_L'))
                        .fontWeight(FontWeight.Medium)
                        .id(COMPONENT_ID_LEFT_BUTTON)
                }
                .backgroundColor($r('app.color.Control_dialog_left_button_background_color'))
                .layoutWeight(1)
                .height($r('app.float.Control_dialog_left_button_height'))
                .onClick(() => {
                    log.showInfo(`left button on click`)
                    if (this.leftAction) {
                        this.leftAction()
                    }
                    this.controller?.close();
                })

                Divider()
                    .vertical(true)
                    .color($r('sys.color.ohos_id_color_list_separator'))
                    .strokeWidth('2px')
                    .height($r('app.float.Control_dialog_divider_height'))
                    .align(Alignment.Center)
                    .margin({left:$r('app.float.Control_dialog_divider_left_margin'), right:$r('app.float.Control_dialog_divider_right_margin')})

                Button({ type: ButtonType.Capsule, stateEffect: true }) {
                    Text(this.rightButton).draggable(false)
                        .fontColor($r('sys.color.font_emphasize'))
                        .fontSize($r('sys.float.Body_L'))
                        .fontWeight(FontWeight.Medium)
                        .id(COMPONENT_ID_RIGHT_BUTTON)
                }
                .backgroundColor($r('app.color.Control_dialog_right_button_background_color'))
                .layoutWeight(1)
                .height($r('app.float.Control_dialog_right_button_height'))
                .onClick(() => {
                    log.showInfo(`right button on click`)
                    if (this.rightAction) {
                        this.rightAction()
                    }
                    this.controller?.close();
                })
            }
            .height($r('app.float.Control_dialog_row_height'))
        }
        .width($r('app.float.Control_dialog_height'))
        .margin({left:$r('sys.float.ohos_id_dialog_margin_start'), right: $r('sys.float.ohos_id_dialog_margin_end')})
        .padding({ left: $r('app.float.Control_dialog_left_padding'), right: $r('app.float.Control_dialog_right_padding'), bottom: $r('app.float.Control_dialog_bottom_padding') })
        .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
    }
}