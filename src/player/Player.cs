using Godot;
using System;

public partial class Player : CharacterBody3D
{
    [Export] public float PlayerSpeed { get; set; } = 5.0f;
    [Export] public float JumpForce { get; set; } = 3.0f;
    [Export] public float Gravity { get; set; } = 8.0f;
    [Export] public float MouseSensitivity { get; set; } = 0.5f;

    private Node3D player;
    private Node3D head;
    private Vector3 direction = Vector3.Zero;
    private float camXDeg = 0.0f;

    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;
        player = GetNode<Node3D>(".");
        head = GetNode<Node3D>("head");
    }

    public override void _Input(InputEvent @event)
    {
        switch (@event)
        {
            case InputEventMouseButton mouseButton when mouseButton.IsPressed():
                if (mouseButton.ButtonIndex == MouseButton.Left)
                {
                    Input.MouseMode = Input.MouseModeEnum.Captured;
                }
                break;

            case InputEventMouseButton mouseButton when !mouseButton.IsPressed():
                if (mouseButton.ButtonIndex == MouseButton.Left)
                {
                    Input.MouseMode = Input.MouseModeEnum.Visible;
                }
                break;
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        direction = Input.GetAxis("left", "right") * player.Basis.X + 
                    Input.GetAxis("forward", "backwards") * player.Basis.Z;
        Velocity = direction.Normalized() * PlayerSpeed + Velocity.Y * Vector3.Up;

        if (Input.IsActionJustPressed("jump") && IsOnFloor())
        {
            Velocity = new Vector3(Velocity.X, JumpForce, Velocity.Z);
        }
        else
        {
            Velocity = new Vector3(Velocity.X, Velocity.Y - Gravity * (float)delta, Velocity.Z);
        }

        MoveAndSlide();
    }
}
