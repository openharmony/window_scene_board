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
import { Singleton } from './Singleton';
// import { hdsEffect } from '@kit.UIDesignKit';
import uiEffect from '@ohos.graphics.uiEffect';
import {
  BackgroundType,
  LiveWeatherModel, LocationType,
  PriorityWeatherScene,
  PriorityWeatherType,
  WeatherScene, WeatherType } from '../live/model/LiveWeatherModel';
import { ResUtils } from '@ohos/windowscene';
import { SystemUICcmConfig } from './SystemUICcmConfig'
import { EnvVm } from '../vm/EnvVm';


const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCardWeatherUtil');

export interface WeatherIconInfo {
  resource?: Resource,
  resourceColor?: ResourceColor[],
}

export class LiveCardWeatherUtil {
  @Singleton.decorate()
  public static get instance(): LiveCardWeatherUtil {
    return new LiveCardWeatherUtil();
  }

  public setHdsEffect(isAnimal: boolean, keepTime: number = 5000, weatherType?: WeatherType): uiEffect.VisualEffect {
    // const liveVisualEffect:ESObject =
    //   new hdsEffect.HdsEffectBuilder()
    //     .weatherAtmosphere(this.getWeatherType(weatherType), isAnimal, {
    //       imageResource: $r('app.media.default_icon'),
    //       onStart: () => {
    //         log.showInfo(`hds onstart ${isAnimal}, keepTime ${keepTime}, wetherType ${weatherType}`);
    //       },
    //       animateParam: {
    //         duration: SystemUICcmConfig.instance.liveConfig.isShowWeatherAnimationWhenExpandCard() ? keepTime :
    //           -1, //时间参数, -1代表取某静态帧作为背景
    //         expectedFrameRateRange: { min: 30, max: 30, expected: 30 },
    //         onFinish: () => {
    //           log.showInfo(`hds onfinish ${isAnimal}, keepTime ${keepTime}, wetherType ${weatherType}`);
    //         },
    //       },
    //       animationArea: {
    //         start: '50%',
    //         top: '0%',
    //         width: '50%',
    //         height: '50%'
    //       }
    //     })
    //     .buildEffect();
    // return liveVisualEffect;
    return uiEffect.createEffect()
  }

  // public getWeatherType(weatherType?: WeatherType): hdsEffect.WeatherAtmosphereScene | undefined {
  //   if (!weatherType) {
  //     log.showError(`weather type is error ${weatherType}`);
  //     return undefined;
  //   }
  //   let weather: hdsEffect.WeatherAtmosphereScene | undefined = undefined;
  //   switch (weatherType) {
  //     case WeatherType.WEATHER_TYPE_LIGHT_RAIN:
  //       weather = hdsEffect.WeatherAtmosphereScene.LIGHT_RAIN;
  //       break;
  //     case WeatherType.WEATHER_TYPE_MODERATE_RAIN:
  //       weather = hdsEffect.WeatherAtmosphereScene.MODERATE_RAIN;
  //       break;
  //     case WeatherType.WEATHER_TYPE_HEAVY_RAIN:
  //       weather = hdsEffect.WeatherAtmosphereScene.HEAVY_RAIN;
  //       break;
  //     case WeatherType.WEATHER_TYPE_LIGHT_SNOW:
  //       weather = hdsEffect.WeatherAtmosphereScene.LIGHT_SNOW;
  //       break;
  //     case WeatherType.WEATHER_TYPE_MODERATE_SNOW:
  //       weather = hdsEffect.WeatherAtmosphereScene.MODERATE_SNOW;
  //       break;
  //     case WeatherType.WEATHER_TYPE_HEAVY_SNOW:
  //       weather = hdsEffect.WeatherAtmosphereScene.HEAVY_SNOW;
  //       break;
  //     default:
  //       weather = hdsEffect.WeatherAtmosphereScene.SAND_DUST;
  //       break;
  //   }
  //   return weather;
  // }

  public getWeatherImage(weatherType?: WeatherType): WeatherIconInfo {
    if (!weatherType) {
      log.showError(`weather type is ${weatherType}`);
      return { resource: undefined, resourceColor: undefined };
    }
    let weatherImage: Resource | undefined = undefined;
    let weatherImageColor: ResourceColor[] | undefined = undefined;
    switch (weatherType) {
      case WeatherType.WEATHER_TYPE_LIGHT_RAIN:
        weatherImage = $r('sys.symbol.light_rain');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_MODERATE_RAIN:
        weatherImage = $r('sys.symbol.moderate_rain');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_HEAVY_RAIN:
        weatherImage = $r('sys.symbol.heavy_rain');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_LIGHT_SNOW:
        weatherImage = $r('sys.symbol.lightsnow');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_MODERATE_SNOW:
        weatherImage = $r('sys.symbol.moderatesnow');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_HEAVY_SNOW:
        weatherImage = $r('sys.symbol.heavysnow');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SUNNY:
        weatherImage = $r('sys.symbol.sun_max_fill_1');
        weatherImageColor = ['#FFD14E'];
        break;
      case WeatherType.WEATHER_TYPE_HAZY:
        weatherImage = $r('sys.symbol.haze');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_CLOUDY:
        weatherImage = $r('sys.symbol.cloud_sun_fill');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary'), '#FFD14E'];
        break;
      case WeatherType.WEATHER_TYPE_OVERCAST:
        weatherImage = $r('sys.symbol.cloud_fill');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_FOG:
        weatherImage = $r('sys.symbol.foggy');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SHOWERS:
        weatherImage = $r('sys.symbol.showers');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_T_STORMS:
        weatherImage = $r('sys.symbol.thunder_storm');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_RAIN:
        weatherImage = $r('sys.symbol.moderate_rain');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SNOW:
        weatherImage = $r('sys.symbol.snowflake');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_RAIN_AND_SNOW:
        weatherImage = $r('sys.symbol.sleet');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_HOT:
        weatherImage = $r('sys.symbol.thermometer_sun_fill');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary'), '#FFD14E'];
        break;
      case WeatherType.WEATHER_TYPE_COLD:
        weatherImage = $r('sys.symbol.thermometer_snowflake');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary'), '#ff00ffea'];
        break;
      case WeatherType.WEATHER_TYPE_WINDY:
        weatherImage = $r('sys.symbol.wind');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_THUNDERSHOWER_WITH_HAIL:
        weatherImage = $r('sys.symbol.thunder_storm');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary'), '#FFD14E'];
        break;
      case WeatherType.WEATHER_TYPE_STORM:
        weatherImage = $r('sys.symbol.heavy_storm');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SEVERE_STORM:
        weatherImage = $r('sys.symbol.heavy_storm');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SNOW_STORM:
        weatherImage = $r('sys.symbol.snowstorm');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_DUST_STORM:
        weatherImage = $r('sys.symbol.wind_sand');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_DUST:
        weatherImage = $r('sys.symbol.wind_sand');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SAND:
        weatherImage = $r('sys.symbol.wind_sand');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      case WeatherType.WEATHER_TYPE_SAND_STORM:
        weatherImage = $r('sys.symbol.wind_sand');
        weatherImageColor = [$r('sys.color.ohos_id_color_primary_contrary')];
        break;
      default:
        break;
    }
    return { resource: weatherImage, resourceColor: weatherImageColor };
  }

  public getAccessibilityTemperatureText(high?: Length, low?: Length): string {
    try {
      if (!high || !low) {
        return '';
      }
      const highTem = String(high) + '°';
      const lowTem = String(low) + '°';
      const highLowTempText = ResUtils.getInnerStringNumS($r('app.string.talkback_temperature'), highTem, lowTem);
      log.showInfo(`highTemperature ${high}, lowTemperature ${high}, result text ${highLowTempText}`);
      return highLowTempText;
    } catch (e) {
      log.showError(`get Accessibility TemperatureText error ${e}`)
    }
    return ''
  }

  public getBackgroundImage(weatherInfo?: LiveWeatherModel, scene?: WeatherScene): Resource | undefined {
    if (!weatherInfo?.showType) {
      return undefined;
    }
    if (this.isNeedCloudBackground(weatherInfo)) {
      return $r('app.media.snow_cloud_background');
    }
    if (weatherInfo?.showType !== PriorityWeatherScene.MOON_SCENE &&
      weatherInfo?.showType !== PriorityWeatherScene.SUNSET_SCENE) {
      return undefined;
    }
    if (weatherInfo?.showType === PriorityWeatherScene.SUNSET_SCENE) {
      return $r('app.media.flight_sunset');
    }
    if (scene === WeatherScene.NOTIFICATION_CENTER) {
      if (EnvVm.instance.isDarkMode) {
        return $r('app.media.flight_moon');
      } else {
        return $r('app.media.flight_moon_light');
      }
    }
    return $r('app.media.flight_moon');
  }

  public isNeedCloudBackground(wetherInfo?: LiveWeatherModel): boolean {
    if ((wetherInfo?.weatherType === WeatherType.WEATHER_TYPE_LIGHT_SNOW ||
      wetherInfo?.weatherType === WeatherType.WEATHER_TYPE_MODERATE_SNOW ||
      wetherInfo?.weatherType === WeatherType.WEATHER_TYPE_HEAVY_SNOW) &&
      wetherInfo?.showType === PriorityWeatherScene.WEATHER_SCENE) {
      return true;
    }
    return false;
  }
}