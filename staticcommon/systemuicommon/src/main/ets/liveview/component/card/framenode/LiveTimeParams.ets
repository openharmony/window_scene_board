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
import { TimeTextStyle } from '../../../../immersivekeyguardcommon/base/interface/TimeTextStyle';
import { ImmersiveAodStyle } from '../../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { LiveTimerData } from '../../../data/extend/LiveTimerData';

/**
 * 实况卡片时间参数
 */
export class LiveTimeParams extends Object {
  /**
   * 计时器数据
   */
  public timeData?: LiveTimerData;
  public viewFontSize?: Resource = $r('app.float.live_view_card_text_font_size');
  public viewFontColor?: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public timeTextStyle?: TimeTextStyle;
  public marginBottom?: number | Resource = $r('app.float.live_view_card_title_margin_bottom');
  public isBigTextTimer?: boolean = false;
  public isTitle?: boolean = true;
  public notificationType?: number;
  public aodStyle?: ImmersiveAodStyle;
}