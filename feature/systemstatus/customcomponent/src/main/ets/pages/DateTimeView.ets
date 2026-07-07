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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DateTimeVM } from '../vm/DateTimeVM';
import { DateUtils } from '../common/DateUtils';
import {
  AodStyleType,
  ImmersiveAodStyle,
  immersiveKgMgr,
  FontScaleState
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationType } from '@ohos/systemuicommon/Index';

const TAG = 'DateTimeView'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 时间格式化显示
 * 主要用于通知时间场景
 *
 * @since 2022-12-10
 */
@Component
export struct DateTimeView {
  /**
   * 时间文本
   */
  @State timeText: string = '';

  /**
   * 字体大小
   */
  private fontSize: Resource | string = '';

  /**
   * 字体颜色
   */
  private fontColor: ResourceColor = '#00000000';

  /**
   * 字体样式，默认Regular
   */
  private fontWeight: FontWeight = FontWeight.Regular;

  /**
   * 唯一标示
   */
  private slot: string = '';

  /**
   * 起始时间，基准时间
   */
  @Prop @Watch('updateTimeMillis') timeMillis: number = 0;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);

  /**
   * VM
   */
  private dateTimeVm: DateTimeVM = new DateTimeVM();

  private transitionEffect:TransitionEffect | undefined = undefined;
  private textOpacity: number | undefined = undefined;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear this.timeMillis: ${this.timeMillis}`);
    this.dateTimeVm.initOv(this.timeMillis, this.slot, this);
  }

  aboutToDisappear(): void {
    this.dateTimeVm.onDestroy();
  }

  /**
   * 更新vm基准时间
   */
  updateTimeMillis(): void {
    log.showInfo(`updateTimeMillis this.timeMillis: ${this.timeMillis}`);
    this.dateTimeVm.updateOvTimeMillis(this.timeMillis);
  }

  /**
   * 复写，时间文本更新回调
   *
   * @param timeText 时间文本
   */
  onTimeTextUpdate(timeText: string): void {
    this.timeText = timeText;
  }

  build() {
    if (!CommonUtils.isEmpty(this.timeText)) {
      Text(this.timeText).draggable(false)
        .fontSize(this.fontSize)
        .maxFontScale(FontScaleState.timeMaxScale)
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) : this.fontColor)
        .fontWeight(this.fontWeight)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .id(`${TAG}_Text_${this.slot}`)
        .transition(this.transitionEffect)
        .opacity(this.textOpacity)
    }
  }
}