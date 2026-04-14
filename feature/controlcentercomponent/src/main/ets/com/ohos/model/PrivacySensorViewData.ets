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
// import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

/**
 * 隐私指示器ViewData类
 */
// instrument ignore next
@Observed
export class PrivacySensorViewData {
  /**
   * 指示器类型列表
   */
  public privacySensorTypeArray: ESObject[] = [];
  /**
   * 多媒体指示器列表
   */
  public multimediaSensorTypeArray: boolean[] = [false, false, false];
  /**
   * 多媒体指示器转场ID
   */
  public multimediaGeometryTransitionId: string[] = ['bracketKitCard', 'soundEffectCard', 'videoEffectCard'];
  /**
   * 是否都是近期访问权限的应用
   */
  public isOnlyAccessed: boolean = false;
  /**
   * 近期访问隐私的应用名称
   */
  public recentAppName: string = '';
  /**
   * 是否有应用访问隐私权限
   */
  public isApplicationInterview: boolean = false;
  /**
   * 是否显示文字
   */
  public isShowText: boolean = true;
  /**
   * 隐私指示器图标尺寸
   */
  public privacySensorImgSize: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_img_size'));
  /**
   * 隐私指示器箭头宽度
   */
  public privacySensorArrowWidth: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_arrow_width'));
  /**
   * 隐私指示器箭头高度
   */
  public privacySensorArrowHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_arrow_height'));
  /**
   * 隐私指示器高度
   */
  public privacySensorWidth: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_width'));
  /**
   * 隐私指示器高度
   */
  public privacySensorHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_height'));
  /**
   * 隐私指示器文字尺寸
   */
  public privacySensorFontSize: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_font_size'));
  /**
   * 隐私指示器文本行高
   */
  public privacySensorLineHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_privacy_line_height'));
  /**
   * 是否镜像语言
   */
  public isRTL: boolean = false;
  /**
   * 点击热区左右间距
   */
  public hotPadding: number = 8;
  /**
   * 文字最大显示宽度
   */
  public textMaxWidth: number = 129;
}