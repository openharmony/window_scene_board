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

/**
 * 实况计时器数据
 */

@Observed
export class LiveWeatherModel {
  /**
   * 天气最高温度，当前只支持摄氏度，历史最高气温58℃
   */
  highTemperature?: number;
  /**
   * 天气最低温度，当前只支持摄氏度，历史最低气温-95℃
   */
  lowTemperature?: number;
  /**
   * weatherType不传入或传入非法值，则不展示天气
   */
  weatherType?: WeatherType;
  /**
   * locationType不传入或传入非法值，则不展示天气
   */
  locationType?: LocationType;
  /**
   * backgroundType不传入或传入非法值，则不展示背景
   */
  backgroundType?: BackgroundType;
  /**
   * 天气展示类型
   */
  showType?: PriorityWeatherScene;
  /**
   * 天气胶囊是否展示
   */
  isWeatherCapsuleShow?: boolean;
  /**
   * 天气动效是否走更新动效
   */
  isUpdateAnimation?: boolean;
}

export enum LocationType {
  // 无定义的位置类型
  LOCATION_TYPE_DEFAULT = 0,
  // 本地的位置类型
  LOCATION_TYPE_LOCAL = 1,
  // 目的地的位置类型
  LOCATION_TYPE_DESTINATION = 2,
}

export enum BackgroundType {
  // 无定义的类型
  SYS_BACKGROUND_UNDEFINED = 0,
  // 赏月背景
  SYS_BACKGROUND_FLIGHT_MOON = 100,
  // 夕阳背景
  SYS_BACKGROUND_FLIGHT_SUNSET = 101,
}

export enum WeatherType {
  // 无定义的天气类型
  WEATHER_TYPE_DEFAULT = 0,

  // 天晴天气类型
  WEATHER_TYPE_SUNNY = 1,

  // 霾天气类型
  WEATHER_TYPE_HAZY = 5,

  // 多云天气类型
  WEATHER_TYPE_CLOUDY = 7,

  // 阴天气类型
  WEATHER_TYPE_OVERCAST = 8,

  // 雾天气类型
  WEATHER_TYPE_FOG = 11,

  // 阵雨天气类型
  WEATHER_TYPE_SHOWERS = 12,

  // 雷阵雨天气类型
  WEATHER_TYPE_T_STORMS = 15,

  // 雨天气类型
  WEATHER_TYPE_RAIN = 18,

  // 雪天气类型
  WEATHER_TYPE_SNOW = 22,

  // 雨夹雪天气类型
  WEATHER_TYPE_RAIN_AND_SNOW = 29,

  // 炎热天气类型
  WEATHER_TYPE_HOT = 30,

  // 寒冷天气类型
  WEATHER_TYPE_COLD = 31,

  // 有风天气类型
  WEATHER_TYPE_WINDY = 32,

  // 冰雹天气类型
  WEATHER_TYPE_THUNDERSHOWER_WITH_HAIL = 45,

  // 小雨天气类型
  WEATHER_TYPE_LIGHT_RAIN = 46,

  // 中雨天气类型
  WEATHER_TYPE_MODERATE_RAIN = 47,

  // 大雨天气类型
  WEATHER_TYPE_HEAVY_RAIN = 48,

  // 暴雨天气类型
  WEATHER_TYPE_STORM = 49,

  // 特大暴雨天气类型
  WEATHER_TYPE_SEVERE_STORM = 51,

  // 小雪天气类型
  WEATHER_TYPE_LIGHT_SNOW = 52,

  // 中雪天气类型
  WEATHER_TYPE_MODERATE_SNOW = 53,

  // 大雪天气类型
  WEATHER_TYPE_HEAVY_SNOW = 54,

  // 暴雪天气类型
  WEATHER_TYPE_SNOW_STORM = 55,

  // 沙尘暴天气类型
  WEATHER_TYPE_DUST_STORM = 56,

  // 浮尘天气类型
  WEATHER_TYPE_DUST = 65,

  // 扬沙天气类型
  WEATHER_TYPE_SAND = 66,

  // 强沙尘暴天气类型
  WEATHER_TYPE_SAND_STORM = 67,

  // 无天气动效类型
  WEATHER_TYPE_INVALID = 200,
}

// 优先展示天气类型
export enum PriorityWeatherType {
  // 小雨天气类型
  WEATHER_TYPE_LIGHT_RAIN = 46,

  // 中雨天气类型
  WEATHER_TYPE_MODERATE_RAIN = 47,

  // 大雨天气类型
  WEATHER_TYPE_HEAVY_RAIN = 48,

  // 小雪天气类型
  WEATHER_TYPE_LIGHT_SNOW = 52,

  // 中雪天气类型
  WEATHER_TYPE_MODERATE_SNOW = 53,

  // 大雪天气类型
  WEATHER_TYPE_HEAVY_SNOW = 54,
}

export enum WeatherCapsuleType {
  // 天气图标
  WEATHER_ICON = 0,
  // 天气胶囊
  WEATHER_TEMPERATURE = 1,
}

export enum WeatherScene {
  // 通知中心
  NOTIFICATION_CENTER = 0,
  // 实况列表或者横幅
  LIVE_LIST_OR_HEADS_UP = 1,
}

export enum PriorityWeatherScene {
  // 不展示
  INVALID_SCENE = 0,
  // 夕阳
  SUNSET_SCENE = 1,
  // 赏月
  MOON_SCENE = 2,
  // 雨雪天气
  WEATHER_SCENE = 3,
}
