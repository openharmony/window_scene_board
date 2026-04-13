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
import { ImageInfo,
  NoAnchorPointOverallPageLayOutInfo,
  OverlayBoxInfo, RadioInfo, TextInfo } from '../model/LiveCardWalletStatusInfoVm';
import { AnimationStage, ShowStage, SweepStage } from '../vm/LiveHeadsUpWalletCardVm';
import { ILiveHeadsUpCardVm } from './ILiveHeadsUpCardVm';
import { AnimatorResult } from '@kit.ArkUI';

export interface ILiveHeadsUpWalletCardVm extends ILiveHeadsUpCardVm {
  imageInfo: ImageInfo;
  textInfo: TextInfo;
  radioInfo: RadioInfo;
  overlayBoxInfo: OverlayBoxInfo;
  noAnchorPointOverallPageLayOutInfo: NoAnchorPointOverallPageLayOutInfo;
  bannerWidthConstant: number;
  bannerLengthConstant: number;
  isPlayingRotation: boolean;
  animationStage: AnimationStage;
  sweepingStage: SweepStage;
  swipeExitAnimatorResult?:AnimatorResult;
  largeFontAdaptationHeight: number;
  exitStartTime: number;
  showStage: ShowStage;

  // 横幅宽度根据屏幕计算，屏幕宽度 - 16 -16  388 -32
  bannerWidthConstantFinalState: number;

  // 文字相对位移固定值
  textOffsetDisplacement: number;

  // 图标相对位移是 屏幕宽度 - 16 * 2 横幅宽度/2 + (固定值) 38 - (固定值) 12 - (固定值) 40
  iconOffsetDisplacement: number;

  /*圆角的改变值*/
  borderRadiusChanges: number;

  componentId: string;

  textWidth: number

  getBigFontOffsetY(): number;
}