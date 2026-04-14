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

export interface SpringParams {
  /**
   * 质量 (kg)
   */
  mass: number;
  /**
   * 刚度 (N/m)
   */
  stiffness: number;
  /**
   * 阻尼系数 (N·s/m)
   */
  damping: number;
}

export class CurveUtil {
  /**
   * 弹簧曲线在指定时间执行百分比
   * @param params 弹簧曲线参数
   * @param t 执行时间(单位 /s)
   * @returns 百分比（单位 /%）
   */
  public static getSpringProgress(params: SpringParams, t: number): number {
    const mass = params.mass;
    const stiffness = params.stiffness;
    const damping = params.damping;

    // 计算阻尼比 (dimensionless)
    const zeta = damping / (2 * Math.sqrt(mass * stiffness));
    // 计算自然频率 (rad/s)
    const omega0 = Math.sqrt(stiffness / mass);

    // 处理不同阻尼状态
    if (zeta > 1) {
      // 过阻尼情况
      const beta = omega0 * Math.sqrt(zeta * zeta - 1);
      const r1 = -zeta * omega0 + beta;
      const r2 = -zeta * omega0 - beta;

      // 过阻尼位移方程
      const displacement = 1 - (r2 * Math.exp(r1 * t) - r1 * Math.exp(r2 * t)) / (r2 - r1);

      return Math.min(100, Math.max(0, displacement * 100));
    } else if (zeta < 1) {
      // 欠阻尼情况 (最常见)
      const omega = omega0 * Math.sqrt(1 - zeta * zeta);
      const phase = Math.atan2(zeta, Math.sqrt(1 - zeta * zeta));

      // 欠阻尼位移方程
      const displacement = 1 - Math.exp(-zeta * omega0 * t) * (
        Math.cos(omega * t - phase) / Math.cos(phase)
      );

      // 百分比可能在振荡时超过0-100范围
      return displacement * 100;
    } else {
      // 临界阻尼情况
      const displacement = 1 - (1 + omega0 * t) * Math.exp(-omega0 * t);

      return Math.min(100, Math.max(0, displacement * 100));
    }
  }

  /**
   * 线性曲线在指定时间执行的百分比
   * @param duration 持续时间
   * @param t 执行时间
   * @returns 百分比
   */
  public static getLinearProgress(duration: number, t: number): number {
    return Math.min(100, t / duration * 100);
  }
}