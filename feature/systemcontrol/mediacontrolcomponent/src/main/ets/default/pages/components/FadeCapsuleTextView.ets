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
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import MeasuringUtil from '../../Util/MeasuringUtil';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

/**
 * 通用文本组件实现渐隐效果
 */
@Component
export struct FadeCapsuleTextView {
  private fontSize: number = 14;
  private fontWeight: number = FontWeight.Medium;
  @Prop fontColor: ResourceColor = Color.Black;
  @Prop text: string = '';
  @Prop isStartMarquee: boolean = false;
  @Prop foreGroundBrightness: BrightnessOptions | undefined = undefined;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  build() {
    Stack() {
      if (this.isStartMarquee) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: !this.isRTL(),
          src: this.text
        })
          .fontWeight(this.fontWeight)
          .fontFamily('HarmonyHeiTi')
          .fontSize(MeasuringUtil.getFontSize(this.fontSize, 1.15, this.getFontSizeScale()))
          .fontColor(this.fontColor)
          .foregroundBrightness(this.foreGroundBrightness)
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .width('100%')
          .height('100%')
          .draggable(false)
          .accessibilityLevel('yes')
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      } else {
        Text(this.text)
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
          .fontWeight(this.fontWeight)
          .fontFamily('HarmonyHeiTi')
          .fontSize(this.fontSize)
          .maxFontScale(1.15)
          .fontColor(this.fontColor)
          .foregroundBrightness(this.foreGroundBrightness)
          .maxLines(1)
          .width('100%')
          .height('100%')
          .draggable(false)
          .wordBreak(WordBreak.BREAK_ALL)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .accessibilityLevel('yes')
      }
    }
    .height('100%')
  }
}
