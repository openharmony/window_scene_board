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
import { LiveCardWeatherUtil } from '../../utils/LiveCardWeatherUtil';
import { EnvVm } from '../../vm/EnvVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveWeatherModel, PriorityWeatherScene, WeatherScene } from '../model/LiveWeatherModel';

export interface WeatherItem {
  contentId: string,
  weatherInfo?: LiveWeatherModel,
  scale?: ScaleOptions,
  scene?: WeatherScene;
  cardHeight?: number;
}

export interface weatherHeight {
  cardHeight?: number;
}

@Builder
export function LiveCardWeatherBackgroundView($$: WeatherItem) {
  Stack() {
    Image(LiveCardWeatherUtil.instance.getBackgroundImage($$.weatherInfo, $$.scene))
      .objectFit(ImageFit.TOP_END)
      .matchTextDirection(true)
      .width('100%')
      .height($$.cardHeight)
    if ($$.weatherInfo?.showType === PriorityWeatherScene.SUNSET_SCENE) {
      sunsetLightGradient()
    } else if ($$.weatherInfo?.showType === PriorityWeatherScene.MOON_SCENE) {
      moonLightGradient()
    } else {
      sunsetLightGradient()
    }
    Column() {
    }
    .width('100%')
    .height('100%')
    .blendMode(7)
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.11 * ResourceVm.instance.getLiveFontScale()],
        ['rgba(255, 255, 255, 0.4)', 0.22],
        ['rgba(255, 255, 255, 0.8)', 0.4],
        ['rgba(255, 255, 255, 1)', 0.6]]
    })

    Column() {
    }
    .width('100%')
    .height('100%')
    .blendMode(7)
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.11 * ResourceVm.instance.getLiveFontScale()],
        ['rgba(255, 255, 255, 0.5)', 0.32],
        ['rgba(255, 255, 255, 0.7)', 0.4],
        ['rgba(255, 255, 255, 0.9)', 0.6]]
    })
  }
  .width('100%')
  .height($$.cardHeight)
  .clip(true)
  .visibility(!EnvVm.instance.isScreenOff ? Visibility.Visible : Visibility.None)
  .borderRadius(LiveStyle.CARD_RADIUS)
  .blendMode(1000, BlendApplyType.OFFSCREEN)
  .hitTestBehavior(HitTestMode.None)
  .scale($$.scale)
}

@Builder
function moonLightGradient() {
  Column() {
  }
  .width('100%')
  .height('100%')
  .blendMode(7)
  .linearGradient({
    direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.5], ['rgba(255, 255, 255, 0.5)', 0.6],
      ['rgba(255, 255, 255, 0.9)', 0.7],
      ['rgba(255, 255, 255, 1)', 1]]
  })

  Column() {
  }
  .width('100%')
  .height('100%')
  .blendMode(7)
  .linearGradient({
    direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.5], ['rgba(255, 255, 255, 0.6)', 0.7],
      ['rgba(255, 255, 255, 1)', 0.8],
      ['rgba(255, 255, 255, 1)', 1]]
  })
}


@Builder
function sunsetLightGradient() {
  Column() {
  }
  .width('100%')
  .height('100%')
  .blendMode(7)
  .linearGradient({
    direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.4], ['rgba(255, 255, 255,0.8)', 0.7],
      ['rgba(255, 255, 255, 1)', 1]]
  })

  Column() {
  }
  .width('100%')
  .height('100%')
  .blendMode(7)
  .linearGradient({
    direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.4], ['rgba(255, 255, 255, 0.7)', 0.7],
      ['rgba(255, 255, 255, 1)', 0.8],
      ['rgba(255, 255, 255, 1)', 1]]
  })
}
@Builder
export function weatherAnimationGradient($$: weatherHeight) {
  Column() {
  }
  .width('100%')
  .height($$.cardHeight)
  .blendMode(7)
  .linearGradient({
    direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.42], ['rgba(255, 255, 255,1.0)', 0.7],
      ['rgba(255, 255, 255, 1)', 1]]
  })

  Column() {
  }
  .width('100%')
  .height($$.cardHeight)
  .blendMode(7)
  .linearGradient({
    direction: GradientDirection.Top,
    colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0)', 0.2], ['rgba(255, 255, 255, 0.6)', 0.4],
      ['rgba(255, 255, 255, 1.0)', 1]]
  })
}
