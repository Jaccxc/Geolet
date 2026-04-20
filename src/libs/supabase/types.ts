export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      card_groups: {
        Row: {
          created_at: string
          id: string
          name: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
        }
        Relationships: []
      }
      customers: {
        Row: {
          id: string
          stripe_customer_id: string | null
        }
        Insert: {
          id: string
          stripe_customer_id?: string | null
        }
        Update: {
          id?: string
          stripe_customer_id?: string | null
        }
        Relationships: []
      }
      fact_cards: {
        Row: {
          answer_region_id: string | null
          card_group_id: string
          card_params: Json | null
          card_type: string
          created_at: string
          difficulty: Database["public"]["Enums"]["fact_difficulty_enum"]
          hint: string | null
          id: string
          primary_skill_tags: string[]
          prompt: string
        }
        Insert: {
          answer_region_id?: string | null
          card_group_id: string
          card_params?: Json | null
          card_type?: string
          created_at?: string
          difficulty?: Database["public"]["Enums"]["fact_difficulty_enum"]
          hint?: string | null
          id?: string
          primary_skill_tags: string[]
          prompt: string
        }
        Update: {
          answer_region_id?: string | null
          card_group_id?: string
          card_params?: Json | null
          card_type?: string
          created_at?: string
          difficulty?: Database["public"]["Enums"]["fact_difficulty_enum"]
          hint?: string | null
          id?: string
          primary_skill_tags?: string[]
          prompt?: string
        }
        Relationships: [
          {
            foreignKeyName: "fact_cards_answer_region_id_fkey"
            columns: ["answer_region_id"]
            isOneToOne: false
            referencedRelation: "regions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fact_cards_card_group_id_fkey"
            columns: ["card_group_id"]
            isOneToOne: false
            referencedRelation: "card_groups"
            referencedColumns: ["id"]
          },
        ]
      }
      game_sessions: {
        Row: {
          created_at: string
          id: string
          mode: string
          summary: Json
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          mode: string
          summary?: Json
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          mode?: string
          summary?: Json
          user_id?: string
        }
        Relationships: []
      }
      insight_rounds: {
        Row: {
          country: string | null
          distance_m: number | null
          id: number
          meta: Json | null
          played_at: string | null
          target_country: string | null
          time_ms: number | null
          user_id: string
        }
        Insert: {
          country?: string | null
          distance_m?: number | null
          id?: number
          meta?: Json | null
          played_at?: string | null
          target_country?: string | null
          time_ms?: number | null
          user_id: string
        }
        Update: {
          country?: string | null
          distance_m?: number | null
          id?: number
          meta?: Json | null
          played_at?: string | null
          target_country?: string | null
          time_ms?: number | null
          user_id?: string
        }
        Relationships: []
      }
      prices: {
        Row: {
          active: boolean | null
          currency: string | null
          description: string | null
          id: string
          interval: Database["public"]["Enums"]["pricing_plan_interval"] | null
          interval_count: number | null
          metadata: Json | null
          product_id: string | null
          trial_period_days: number | null
          type: Database["public"]["Enums"]["pricing_type"] | null
          unit_amount: number | null
        }
        Insert: {
          active?: boolean | null
          currency?: string | null
          description?: string | null
          id: string
          interval?: Database["public"]["Enums"]["pricing_plan_interval"] | null
          interval_count?: number | null
          metadata?: Json | null
          product_id?: string | null
          trial_period_days?: number | null
          type?: Database["public"]["Enums"]["pricing_type"] | null
          unit_amount?: number | null
        }
        Update: {
          active?: boolean | null
          currency?: string | null
          description?: string | null
          id?: string
          interval?: Database["public"]["Enums"]["pricing_plan_interval"] | null
          interval_count?: number | null
          metadata?: Json | null
          product_id?: string | null
          trial_period_days?: number | null
          type?: Database["public"]["Enums"]["pricing_type"] | null
          unit_amount?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "prices_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          active: boolean | null
          description: string | null
          id: string
          image: string | null
          metadata: Json | null
          name: string | null
        }
        Insert: {
          active?: boolean | null
          description?: string | null
          id: string
          image?: string | null
          metadata?: Json | null
          name?: string | null
        }
        Update: {
          active?: boolean | null
          description?: string | null
          id?: string
          image?: string | null
          metadata?: Json | null
          name?: string | null
        }
        Relationships: []
      }
      regions: {
        Row: {
          centroid_lonlat: number[] | null
          country: string | null
          created_at: string
          geometry: Json | null
          id: string
          key: string
          level: Database["public"]["Enums"]["region_level_enum"]
          location_type: Database["public"]["Enums"]["location_type_enum"]
          name: string
          note: string | null
        }
        Insert: {
          centroid_lonlat?: number[] | null
          country?: string | null
          created_at?: string
          geometry?: Json | null
          id?: string
          key: string
          level: Database["public"]["Enums"]["region_level_enum"]
          location_type: Database["public"]["Enums"]["location_type_enum"]
          name: string
          note?: string | null
        }
        Update: {
          centroid_lonlat?: number[] | null
          country?: string | null
          created_at?: string
          geometry?: Json | null
          id?: string
          key?: string
          level?: Database["public"]["Enums"]["region_level_enum"]
          location_type?: Database["public"]["Enums"]["location_type_enum"]
          name?: string
          note?: string | null
        }
        Relationships: []
      }
      skill_tags: {
        Row: {
          country: string | null
          created_at: string
          display: string
          examples: string[] | null
          family: Database["public"]["Enums"]["skill_family_enum"]
          id: string
          key: string
          note: string | null
        }
        Insert: {
          country?: string | null
          created_at?: string
          display: string
          examples?: string[] | null
          family: Database["public"]["Enums"]["skill_family_enum"]
          id?: string
          key: string
          note?: string | null
        }
        Update: {
          country?: string | null
          created_at?: string
          display?: string
          examples?: string[] | null
          family?: Database["public"]["Enums"]["skill_family_enum"]
          id?: string
          key?: string
          note?: string | null
        }
        Relationships: []
      }
      subscriptions: {
        Row: {
          cancel_at: string | null
          cancel_at_period_end: boolean | null
          canceled_at: string | null
          created: string
          current_period_end: string
          current_period_start: string
          ended_at: string | null
          id: string
          metadata: Json | null
          price_id: string | null
          quantity: number | null
          status: Database["public"]["Enums"]["subscription_status"] | null
          trial_end: string | null
          trial_start: string | null
          user_id: string
        }
        Insert: {
          cancel_at?: string | null
          cancel_at_period_end?: boolean | null
          canceled_at?: string | null
          created?: string
          current_period_end?: string
          current_period_start?: string
          ended_at?: string | null
          id: string
          metadata?: Json | null
          price_id?: string | null
          quantity?: number | null
          status?: Database["public"]["Enums"]["subscription_status"] | null
          trial_end?: string | null
          trial_start?: string | null
          user_id: string
        }
        Update: {
          cancel_at?: string | null
          cancel_at_period_end?: boolean | null
          canceled_at?: string | null
          created?: string
          current_period_end?: string
          current_period_start?: string
          ended_at?: string | null
          id?: string
          metadata?: Json | null
          price_id?: string | null
          quantity?: number | null
          status?: Database["public"]["Enums"]["subscription_status"] | null
          trial_end?: string | null
          trial_start?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscriptions_price_id_fkey"
            columns: ["price_id"]
            isOneToOne: false
            referencedRelation: "prices"
            referencedColumns: ["id"]
          },
        ]
      }
      topics: {
        Row: {
          created_at: string
          description: string | null
          difficulty: Database["public"]["Enums"]["difficulty_enum"] | null
          icon: string | null
          id: string
          key: string
          map_mode_active: boolean
          pick_mode_active: boolean
          queue_mode: string
          target_card_group_ids: string[] | null
          title: string
          use_country_region: boolean
        }
        Insert: {
          created_at?: string
          description?: string | null
          difficulty?: Database["public"]["Enums"]["difficulty_enum"] | null
          icon?: string | null
          id?: string
          key: string
          map_mode_active?: boolean
          pick_mode_active?: boolean
          queue_mode?: string
          target_card_group_ids?: string[] | null
          title: string
          use_country_region?: boolean
        }
        Update: {
          created_at?: string
          description?: string | null
          difficulty?: Database["public"]["Enums"]["difficulty_enum"] | null
          icon?: string | null
          id?: string
          key?: string
          map_mode_active?: boolean
          pick_mode_active?: boolean
          queue_mode?: string
          target_card_group_ids?: string[] | null
          title?: string
          use_country_region?: boolean
        }
        Relationships: []
      }
      user_fact_stats: {
        Row: {
          correct: number
          due_at: string | null
          ease: number
          fact_id: string
          last_seen_at: string | null
          seen: number
          user_id: string
        }
        Insert: {
          correct?: number
          due_at?: string | null
          ease?: number
          fact_id: string
          last_seen_at?: string | null
          seen?: number
          user_id: string
        }
        Update: {
          correct?: number
          due_at?: string | null
          ease?: number
          fact_id?: string
          last_seen_at?: string | null
          seen?: number
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_fact_stats_fact_id_fkey"
            columns: ["fact_id"]
            isOneToOne: false
            referencedRelation: "fact_cards"
            referencedColumns: ["id"]
          },
        ]
      }
      users: {
        Row: {
          avatar_url: string | null
          billing_address: Json | null
          full_name: string | null
          id: string
          payment_method: Json | null
        }
        Insert: {
          avatar_url?: string | null
          billing_address?: Json | null
          full_name?: string | null
          id: string
          payment_method?: Json | null
        }
        Update: {
          avatar_url?: string | null
          billing_address?: Json | null
          full_name?: string | null
          id?: string
          payment_method?: Json | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      difficulty_enum: "beginner" | "intermediate" | "advanced"
      fact_difficulty_enum: "1" | "2" | "3"
      location_type_enum: "pin" | "polygon"
      pricing_plan_interval: "day" | "week" | "month" | "year"
      pricing_type: "one_time" | "recurring"
      region_level_enum: "country" | "province" | "city"
      skill_family_enum: "script" | "phone" | "city"
      subscription_status:
        | "trialing"
        | "active"
        | "canceled"
        | "incomplete"
        | "incomplete_expired"
        | "past_due"
        | "unpaid"
        | "paused"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      difficulty_enum: ["beginner", "intermediate", "advanced"],
      fact_difficulty_enum: ["1", "2", "3"],
      location_type_enum: ["pin", "polygon"],
      pricing_plan_interval: ["day", "week", "month", "year"],
      pricing_type: ["one_time", "recurring"],
      region_level_enum: ["country", "province", "city"],
      skill_family_enum: ["script", "phone", "city"],
      subscription_status: [
        "trialing",
        "active",
        "canceled",
        "incomplete",
        "incomplete_expired",
        "past_due",
        "unpaid",
        "paused",
      ],
    },
  },
} as const
